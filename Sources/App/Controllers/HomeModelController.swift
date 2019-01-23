
import Vapor



struct HomeModelController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeModelsRoute = router.grouped("api", "home-model")
		
		homeModelsRoute.post(HomeModel.self, use: createHandler)
		
		homeModelsRoute.get(use: getAllHandler)
		
		homeModelsRoute.get(HomeModel.parameter, use: getHandler)
		
		homeModelsRoute.put(HomeModel.parameter, use: updateHandler)
		
		homeModelsRoute.get(HomeModel.parameter, "line", use: getProductLineHandler)
		
		homeModelsRoute.get(HomeModel.parameter, "home-option-items", use: getHomeOptionItemsHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		line: HomeModel
		) throws -> Future<HomeModel> {
		
		return line.save(on: req)
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
		) { line, updatedLine in
			line.id = updatedLine.id
			line.name = updatedLine.name
			line.logoURL = updatedLine.logoURL
			line.productLineID = updatedLine.productLineID
			return line.save(on: req)
		}
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


