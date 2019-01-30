
import Vapor
import Fluent
import Authentication



struct HomeOptionItemController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionItemsRoute = router.grouped("api", "home-option-item")
		
//		homeOptionItemsRoute.post(HomeOptionItem.self, use: createHandler)
		
		homeOptionItemsRoute.get(use: getAllHandler)
		
		homeOptionItemsRoute.get(HomeOptionItem.parameter, use: getHandler)
		
//		homeOptionItemsRoute.put(HomeOptionItem.parameter, use: updateHandler)

//		homeOptionItemsRoute.delete(HomeOptionItem.parameter, use: deleteHandler)
		
		homeOptionItemsRoute.get(HomeOptionItem.parameter, "builder", use: getBuilderHandler)

		homeOptionItemsRoute.get(DecorOptionItem.parameter, "decor-category", use: getCategoryHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(HomeOptionItem.self, use: createHandler)
		
		tokenAuthGroup.delete(HomeOptionItem.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HomeOptionItem.parameter, use: updateHandler)

	}
	
	
	func createHandler(_ req: Request, homeOptionItem: HomeOptionItem) throws -> Future<HomeOptionItem> {
		
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
			homeOptionItem.categoryID = updatedItem.categoryID
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
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HomeOptionItem.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}

	
	// Get the Builder record for this home option Item
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(HomeOptionItem.self).flatMap(to: HomeBuilder.self) { homeOptionItem in
			
			homeOptionItem.builder.get(on: req)
		}
	}

	
	// Get the category record for this decor Item
	//
	func getCategoryHandler(_ req: Request) throws -> Future<HomeOptionCategory> {
		
		return try req.parameters.next(HomeOptionItem.self).flatMap(to: HomeOptionCategory.self) { optionItem in
			
			optionItem.optionCategory.get(on: req)
		}
	}

	
	
}




