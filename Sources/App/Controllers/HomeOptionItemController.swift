
import Vapor



struct HomeOptionItemController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionItemsRoute = router.grouped("api", "home-option-item")
		
		homeOptionItemsRoute.post(HomeOptionItem.self, use: createHandler)
		
		homeOptionItemsRoute.get(use: getAllHandler)
		
		homeOptionItemsRoute.get(HomeOptionItem.parameter, use: getHandler)
		
		homeOptionItemsRoute.put(HomeOptionItem.parameter, use: updateHandler)
		
		homeOptionItemsRoute.get(HomeOptionItem.parameter, "builder", use: getBuilderHandler)
		
		homeOptionItemsRoute.post(HomeOptionItem.parameter, "home-models", HomeModel.parameter, use: addHomesHandler)
		
		homeOptionItemsRoute.get(HomeOptionItem.parameter, "home-models", use: getHomesHandler)
		
		homeOptionItemsRoute.delete(HomeOptionItem.parameter, "home-models", HomeModel.parameter, 	use: removeHomesHandler)
		
		homeOptionItemsRoute.post(HomeOptionItem.parameter, "categories", HomeOptionCategory.parameter, use: addCategoriesHandler)
		
		homeOptionItemsRoute.get(HomeOptionItem.parameter, "categories", use: getCategoriesHandler)
		
		homeOptionItemsRoute.delete(HomeOptionItem.parameter, "categories", HomeOptionCategory.parameter, 	use: removeCategoriesHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		homeOptionItem: HomeOptionItem
		) throws -> Future<HomeOptionItem> {
		
		return homeOptionItem.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[HomeOptionItem]>
	{
		return HomeOptionItem.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<HomeOptionItem>
	{
		return try req.parameters.next(HomeOptionItem.self)
	}
	
	
	// Update passed product home option Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HomeOptionItem> {
		
		return try flatMap(
			to: HomeOptionItem.self,
			req.parameters.next(HomeOptionItem.self),
			req.content.decode(HomeOptionItem.self)
		) { homeOptionItem, updatedItem in
			
			homeOptionItem.name = updatedItem.name
			homeOptionItem.builderID = updatedItem.builderID
			homeOptionItem.optionType = updatedItem.optionType

			homeOptionItem.optionImageURL = updatedItem.name
			homeOptionItem.optionModelURL = updatedItem.optionModelURL
			homeOptionItem.decorOptionColor = updatedItem.decorOptionColor
			homeOptionItem.imageScale = updatedItem.imageScale
			homeOptionItem.imageScale = updatedItem.imageScale
			homeOptionItem.physicalWidth = updatedItem.physicalWidth
			homeOptionItem.physicalHeight = updatedItem.physicalHeight
			
			return homeOptionItem.save(on: req)
		}
	}
	
	// Get the Builder record for this home option Item
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req
			.parameters.next(HomeOptionItem.self)
			.flatMap(to: HomeBuilder.self) { homeOptionItem in
				
				homeOptionItem.builder.get(on: req)
		}
	}
	
	
	func addHomesHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(HomeOptionItem.self),
			req.parameters.next(HomeModel.self)) { homeOption, model in
				
				return homeOption.homeModels .attach(model, on: req) .transform(to: .created)
		}
	}
	
	
	func getHomesHandler(_ req: Request ) throws -> Future<[HomeModel]> {
		
		return try req.parameters.next(HomeOptionItem.self)
			.flatMap(to: [HomeModel].self) { homeOption in
				
				try homeOption.homeModels.query(on: req).all()
		}
	}
	
	
	func removeHomesHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(HomeOptionItem.self),
			req.parameters.next(HomeModel.self)
		) { optionItem, model in
			
			return optionItem.homeModels .detach(model, on: req) .transform(to: .noContent)
		}
	}

	
	func addCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(HomeOptionItem.self),
			req.parameters.next(HomeOptionCategory.self)) { homeOption, category in
				
				return homeOption.categories .attach(category, on: req) .transform(to: .created)
		}
	}
	
	
	func getCategoriesHandler(_ req: Request ) throws -> Future<[HomeOptionCategory]> {
		
		return try req.parameters.next(HomeOptionItem.self)
			.flatMap(to: [HomeOptionCategory].self) { homeOption in
				
				try homeOption.categories.query(on: req).all()
		}
	}
	
	
	func removeCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(HomeOptionItem.self),
			req.parameters.next(HomeOptionCategory.self)
		) { optionItem, category in
			
			return optionItem.categories .detach(category, on: req) .transform(to: .noContent)
		}
	}

	
}




