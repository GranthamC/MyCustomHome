
import Vapor
import Fluent
import Authentication

struct HomeSetInfoResponse: Content
{
	var setTitle: String
	
	var logoURL: String?
	
	var setDescription: String?
	
	var setIndex: Int16?
	
	var websiteURL: String?
	
	var orderByIndex: Bool?
	var useFactoryTour: Bool?
	var useSlideOverForHomeInfo: Bool?

	var homeModels: [HomeModel]
	
	init(set: HomeModelSet, models: [HomeModel])
	{
		
		self.setTitle = set.setTitle
		self.logoURL = set.logoURL
		self.setDescription = set.setDescription
		self.setIndex = set.setIndex
		
		self.websiteURL = set.websiteURL
		
		self.orderByIndex = set.orderByIndex
		self.useFactoryTour = set.useFactoryTour
		self.useSlideOverForHomeInfo = set.useSlideOverForHomeInfo
		
		self.homeModels = models
	}
}


struct HomeSetController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeSetRoute = router.grouped("api", "home-set")
		
		homeSetRoute.get(use: getAllHandler)
		
		homeSetRoute.get(HomeModelSet.parameter, use: getHandler)
		
		homeSetRoute.get(HomeModelSet.parameter, "home-models", use: getHomeModelsHandler)
		
		homeSetRoute.get("home-sets", use: all)
		
		homeSetRoute.get(HomeModelSet.parameter, "categories", use: getSetCategoriesHandler)

		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeSetRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		tokenAuthGroup.post(HomeModelSet.self, use: createHandler)
		
		tokenAuthGroup.delete(HomeModelSet.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HomeModelSet.parameter, use: updateHandler)
		
		tokenAuthGroup.post(HomeModelSet.parameter, "home-model", HomeModel.parameter, use: addHomeModelHandler)
		
		tokenAuthGroup.delete(HomeModelSet.parameter, "home-model", HomeModel.parameter, use: removeHomeModelHandler)
	}
	
	func all(_ request: Request) throws -> Future<[HomeSetInfoResponse]> {
		
		return HomeModelSet.query(on: request).all().flatMap { homeSets in
			
			let responseFutures = try homeSets.map { set in
				
				try set.homeModels.query(on: request).all().map { models in
					return HomeSetInfoResponse(set: set, models: models)
				}
			}
			
			return responseFutures.flatten(on: request)
		}
	}
	
	func createHandler(_ req: Request, line: HomeModelSet) throws -> Future<HomeModelSet> {
		
		return line.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[HomeModelSet]>
	{
		return HomeModelSet.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<HomeModelSet>
	{
		return try req.parameters.next(HomeModelSet.self)
	}
	
	
	// Update passed product line with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HomeModelSet> {
		
		return try flatMap(
			to: HomeModelSet.self,
			req.parameters.next(HomeModelSet.self),
			req.content.decode(HomeModelSet.self)
		) { homeSet, updatedSet in
			
			homeSet.plantID = updatedSet.plantID
			homeSet.setTitle = updatedSet.setTitle
			homeSet.setDescription = updatedSet.setDescription
			homeSet.useFactoryTour = updatedSet.useFactoryTour
			homeSet.orderByIndex = updatedSet.orderByIndex
			homeSet.useSlideOverForHomeInfo = updatedSet.useSlideOverForHomeInfo
			homeSet.logoURL = updatedSet.logoURL
			homeSet.websiteURL = updatedSet.websiteURL
			homeSet.changeToken = updatedSet.changeToken
			homeSet.homeSetBrochureURL = updatedSet.homeSetBrochureURL
			homeSet.useCategories = updatedSet.useCategories
			homeSet.useBrochure = updatedSet.useBrochure

			return homeSet.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HomeModelSet.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	
	func addHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(HomeModelSet.self), req.parameters.next(HomeModel.self))
		{ line, model in
			
			return line.homeModels.attach(model, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getHomeModelsHandler(_ req: Request) throws -> Future<[HomeModel]> {
		
		return try req.parameters.next(HomeModelSet.self).flatMap(to: [HomeModel].self) { line in
			
			try line.homeModels.query(on: req).all()
		}
	}
	
	func removeHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(HomeModelSet.self), req.parameters.next(HomeModel.self)) { line, model in
			
			return line.homeModels.detach(model, on: req).transform(to: .noContent)
		}
	}
	
	
	// Get the builder's product lines
	//
	func getSetCategoriesHandler(_ req: Request) throws -> Future<[HomeSetCategory]> {
		
		return try req
			.parameters.next(HomeModelSet.self)
			.flatMap(to: [HomeSetCategory].self) { builder in
				
				try builder.homeCategories.query(on: req).all()
		}
	}

	
}


