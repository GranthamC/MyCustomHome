
import Vapor
import Fluent
import Authentication



struct HomeOptionItemController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionItemsRoute = router.grouped("api", "option-item")
		
		homeOptionItemsRoute.get(use: getAllHandler)
		
		homeOptionItemsRoute.get(OptionItem.parameter, use: getHandler)
		
		homeOptionItemsRoute.get(OptionItem.parameter, "category", use: getCategoryHandler)

		homeOptionItemsRoute.get(OptionItem.parameter, "builder", use: getBuilderHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(OptionItem.self, use: createHandler)
		
		tokenAuthGroup.delete(OptionItem.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(OptionItem.parameter, use: updateHandler)
	}
	
	
	func createHandler(_ req: Request, homeOptionItem: OptionItem) throws -> Future<OptionItem> {
		
		return homeOptionItem.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[OptionItem]>
	{
		return OptionItem.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<OptionItem>
	{
		return try req.parameters.next(OptionItem.self)
	}
	
	
	// Update passed product home option Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<OptionItem> {
		
		return try flatMap(
			to: OptionItem.self,
			req.parameters.next(OptionItem.self),
			req.content.decode(OptionItem.self)
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
		
		return try req.parameters.next(OptionItem.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the category record for this option Item
	//
	func getCategoryHandler(_ req: Request) throws -> Future<OptionCategory> {
		
		return try req.parameters.next(OptionItem.self).flatMap(to: OptionCategory.self) { optionItem in
			
			optionItem.category.get(on: req)
		}
	}

	
	// Get the Builder record for this home option Item
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(OptionItem.self).flatMap(to: HomeBuilder.self) { homeOptionItem in
			
			homeOptionItem.builder.get(on: req)
		}
	}
	
	
}




