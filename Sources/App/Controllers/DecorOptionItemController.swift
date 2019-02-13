
import Vapor
import Fluent
import Authentication



struct DecorOptionItemController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionItemsRoute = router.grouped("api", "decor-item")
		
		homeOptionItemsRoute.get(use: getAllHandler)
		
		homeOptionItemsRoute.get(DecorOptionItem.parameter, use: getHandler)
		
		homeOptionItemsRoute.get(DecorOptionItem.parameter, "builder", use: getBuilderHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(DecorOptionItem.self, use: createHandler)
		
		tokenAuthGroup.delete(DecorOptionItem.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(DecorOptionItem.parameter, use: updateHandler)
		
	}
	
	
	func createHandler(_ req: Request, homeOptionItem: DecorOptionItem) throws -> Future<DecorOptionItem> {
		
		return homeOptionItem.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[DecorOptionItem]>
	{
		return DecorOptionItem.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<DecorOptionItem>
	{
		return try req.parameters.next(DecorOptionItem.self)
	}
	
	
	// Update passed product home option Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<DecorOptionItem> {
		
		return try flatMap(
			to: DecorOptionItem.self,
			req.parameters.next(DecorOptionItem.self),
			req.content.decode(DecorOptionItem.self)
		) { optionItem, updatedItem in
			
			optionItem.name = updatedItem.name
			optionItem.builderID = updatedItem.builderID
			optionItem.optionType = updatedItem.optionType
			optionItem.changeToken = updatedItem.changeToken

			optionItem.optionImageURL = updatedItem.optionImageURL
			optionItem.optionModelURL = updatedItem.optionModelURL
			optionItem.detailInfo = updatedItem.detailInfo
			optionItem.optionColor = updatedItem.optionColor
			optionItem.isUpgrade = updatedItem.isUpgrade
			optionItem.imageScale = updatedItem.imageScale
			optionItem.physicalWidth = updatedItem.physicalWidth
			optionItem.physicalHeight = updatedItem.physicalHeight
			
			return optionItem.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(DecorOptionItem.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the Builder record for this home option Item
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(DecorOptionItem.self).flatMap(to: HomeBuilder.self) { homeOptionItem in
			
			homeOptionItem.builder.get(on: req)
		}
	}
	
	
}





