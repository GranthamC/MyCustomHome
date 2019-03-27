
import Vapor
import Fluent
import Authentication



struct BuilderOptionItemController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionItemsRoute = router.grouped("api", "builder-option")
		
		homeOptionItemsRoute.get(use: getAllHandler)
		
		homeOptionItemsRoute.get(BuilderOptionItem.parameter, use: getHandler)
		
		homeOptionItemsRoute.get(BuilderOptionItem.parameter, "category", use: getCategoryHandler)

		homeOptionItemsRoute.get(BuilderOptionItem.parameter, "builder", use: getBuilderHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(BuilderOptionItem.self, use: createHandler)
		
		tokenAuthGroup.delete(BuilderOptionItem.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(BuilderOptionItem.parameter, use: updateHandler)
	}
	
	
	func createHandler(_ req: Request, homeOptionItem: BuilderOptionItem) throws -> Future<BuilderOptionItem> {
		
		return homeOptionItem.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[BuilderOptionItem]>
	{
		return BuilderOptionItem.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<BuilderOptionItem>
	{
		return try req.parameters.next(BuilderOptionItem.self)
	}
	
	
	// Update passed product home option Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<BuilderOptionItem> {
		
		return try flatMap(
			to: BuilderOptionItem.self,
			req.parameters.next(BuilderOptionItem.self),
			req.content.decode(BuilderOptionItem.self)
		) { optionItem, updatedItem in
			
			optionItem.name = updatedItem.name
			optionItem.builderID = updatedItem.builderID
			optionItem.optionImageType = updatedItem.optionImageType
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
		
		return try req.parameters.next(BuilderOptionItem.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the category record for this option Item
	//
	func getCategoryHandler(_ req: Request) throws -> Future<BuilderOptionCategory> {
		
		return try req.parameters.next(BuilderOptionItem.self).flatMap(to: BuilderOptionCategory.self) { optionItem in
			
			optionItem.category.get(on: req)
		}
	}

	
	// Get the Builder record for this home option Item
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(BuilderOptionItem.self).flatMap(to: HomeBuilder.self) { homeOptionItem in
			
			homeOptionItem.builder.get(on: req)
		}
	}
	
	
}




