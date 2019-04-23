
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
	
	init(set: BuilderHomeSet, models: [HomeModel])
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
		
		homeSetRoute.get(BuilderHomeSet.parameter, use: getHandler)
		
		homeSetRoute.get(BuilderHomeSet.parameter, "home-models", use: getHomeModelsHandler)
		
		homeSetRoute.get("home-sets", use: all)
		
		homeSetRoute.get(BuilderHomeSet.parameter, "categories", use: getSetCategoriesHandler)

		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeSetRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		tokenAuthGroup.post(BuilderHomeSet.self, use: createHandler)
		
		tokenAuthGroup.delete(BuilderHomeSet.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(BuilderHomeSet.parameter, use: updateHandler)
		
		tokenAuthGroup.post(BuilderHomeSet.parameter, "home-model", HomeModel.parameter, use: addHomeModelHandler)
		
		tokenAuthGroup.delete(BuilderHomeSet.parameter, "home-model", HomeModel.parameter, use: removeHomeModelHandler)
	}
	
	func all(_ request: Request) throws -> Future<[HomeSetInfoResponse]> {
		
		return BuilderHomeSet.query(on: request).all().flatMap { homeSets in
			
			let responseFutures = try homeSets.map { set in
				
				try set.homeModels.query(on: request).all().map { models in
					return HomeSetInfoResponse(set: set, models: models)
				}
			}
			
			return responseFutures.flatten(on: request)
		}
	}
	
	func createHandler(_ req: Request, line: BuilderHomeSet) throws -> Future<BuilderHomeSet> {
		
		return line.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[BuilderHomeSet]>
	{
		return BuilderHomeSet.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<BuilderHomeSet>
	{
		return try req.parameters.next(BuilderHomeSet.self)
	}
	
	
	// Update passed product line with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<BuilderHomeSet> {
		
		return try flatMap(
			to: BuilderHomeSet.self,
			req.parameters.next(BuilderHomeSet.self),
			req.content.decode(BuilderHomeSet.self)
		) { homeSet, updatedSet in
			
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
		
		return try req.parameters.next(BuilderHomeSet.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	
	func addHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(BuilderHomeSet.self), req.parameters.next(HomeModel.self))
		{ line, model in
			
			return line.homeModels.attach(model, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getHomeModelsHandler(_ req: Request) throws -> Future<[HomeModel]> {
		
		return try req.parameters.next(BuilderHomeSet.self).flatMap(to: [HomeModel].self) { line in
			
			try line.homeModels.query(on: req).all()
		}
	}
	
	func removeHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(BuilderHomeSet.self), req.parameters.next(HomeModel.self)) { line, model in
			
			return line.homeModels.detach(model, on: req).transform(to: .noContent)
		}
	}
	
	
	// Get the builder's product lines
	//
	func getSetCategoriesHandler(_ req: Request) throws -> Future<[HomeSetCategory]> {
		
		return try req
			.parameters.next(BuilderHomeSet.self)
			.flatMap(to: [HomeSetCategory].self) { builder in
				
				try builder.homeCategories.query(on: req).all()
		}
	}

	
}


