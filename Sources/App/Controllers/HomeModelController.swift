
import Vapor
import Fluent
import Authentication


struct HomeModelController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeModelsRoute = router.grouped("api", "home-model")
		
//		homeModelsRoute.post(HomeModel.self, use: createHandler)
		
		homeModelsRoute.get(use: getAllHandler)
		
		homeModelsRoute.get(HomeModel.parameter, use: getHandler)
		
//		homeModelsRoute.put(HomeModel.parameter, use: updateHandler)

//		homeModelsRoute.delete(HomeBuilder.parameter, use: deleteHandler)
		
		homeModelsRoute.get("search", use: searchHandler)
		
		homeModelsRoute.get("first", use: getFirstHandler)
		
		homeModelsRoute.get("sorted", use: sortedHandler)

		homeModelsRoute.get(HomeModel.parameter, "line", use: getProductLineHandler)
		
		homeModelsRoute.get(HomeModel.parameter, "home-option-items", use: getHomeOptionItemsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeModelsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(HomeModel.self, use: createHandler)
		
		tokenAuthGroup.delete(HomeModel.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HomeModel.parameter, use: updateHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		model: HomeModel
		) throws -> Future<HomeModel> {
		
		return model.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[HomeModel]>
	{
		return HomeModel.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<HomeModel>
	{
		return try req.parameters.next(HomeModel.self)
	}
	
	
	// Update passed home model with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HomeModel> {
		
		return try flatMap(
			to: HomeModel.self,
			req.parameters.next(HomeModel.self),
			req.content.decode(HomeModel.self)
		) { model, updatedModel in
			
			model.name = updatedModel.name
			model.modelNumber = updatedModel.modelNumber
			model.productLineID = updatedModel.productLineID
			
			model.heroImageURL = updatedModel.heroImageURL
			model.matterportTourURL = updatedModel.matterportTourURL
			model.panoModelTourURL = updatedModel.panoModelTourURL

			model.sqft = updatedModel.sqft
			model.baths = updatedModel.baths
			model.beds = updatedModel.beds
			model.features = updatedModel.features
			model.priceBase = updatedModel.priceBase
			model.priceUpper = updatedModel.priceUpper

			model.isEnabled = updatedModel.isEnabled
			model.isSingleSection = updatedModel.isSingleSection

			model.hasBasement = updatedModel.hasBasement
			model.sqftBasement = updatedModel.sqftBasement
			model.sqftMain = updatedModel.sqftMain
			model.sqftUpper = updatedModel.sqftUpper

			return model.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HomeModel.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	func searchHandler(_ req: Request) throws -> Future<[HomeModel]>
	{
		guard let searchTerm = req.query[String.self, at: "param"] else {
			throw Abort(.badRequest)
		}
		
		return HomeModel.query(on: req).group(.or) { or in
			or.filter(\.name == searchTerm)
			or.filter(\.modelNumber == searchTerm)
			}.all()
	}
	
	
	func getFirstHandler(_ req: Request) throws -> Future<HomeModel>
	{
		return HomeModel.query(on: req)
			.first()
			
			.map(to: HomeModel.self) { homemodel in
				guard let model = homemodel else {
					throw Abort(.notFound)
				}
				
				return model
		}
	}
	
	
	func sortedHandler(_ req: Request) throws -> Future<[HomeBuilder]>
	{
		return HomeBuilder.query(on: req).sort(\.name, .ascending).all()
	}
	
	

	// Get the Product line record for this home model
	//
	func getProductLineHandler(_ req: Request) throws -> Future<ProductLine> {
		
		return try req
			.parameters.next(HomeModel.self)
			.flatMap(to: ProductLine.self) { home in
				
				home.productLine.get(on: req)
		}
	}
	
	
	func getHomeOptionItemsHandler(_ req: Request) throws -> Future<[HomeOptionItem]> {
		
		return try req.parameters.next(HomeModel.self)
			.flatMap(to: [HomeOptionItem].self) { model in
				
				try model.homeOptions.query(on: req).all()
		}
	}

	
}


