
import Vapor
import Fluent
import Authentication



struct HomeOptionItemController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionItemsRoute = router.grouped("api", "option-item")
		
		homeOptionItemsRoute.get(use: getAllHandler)
		
		homeOptionItemsRoute.get(HomeOptionItem.parameter, use: getHandler)
		
		homeOptionItemsRoute.get(HomeOptionItem.parameter, "builder", use: getBuilderHandler)
		
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
		) { optionItem, updatedItem in
			
			optionItem.name = updatedItem.name
			optionItem.builderID = updatedItem.builderID
			optionItem.optionType = updatedItem.optionType

			optionItem.optionImageURL = updatedItem.optionImageURL
			optionItem.optionModelURL = updatedItem.optionModelURL
			optionItem.description = updatedItem.description
			optionItem.optionColor = updatedItem.optionColor
			optionItem.imageScale = updatedItem.imageScale
			optionItem.physicalWidth = updatedItem.physicalWidth
			optionItem.physicalHeight = updatedItem.physicalHeight
			
			return optionItem.save(on: req)
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
	
	
}




