
import Vapor
import Fluent
import Authentication



struct DecorOptionItemController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let decorOptionItemsRoute = router.grouped("api", "decor-item")
		
		decorOptionItemsRoute.get(use: getAllHandler)
		
		decorOptionItemsRoute.get(DecorItem.parameter, use: getHandler)
		
		decorOptionItemsRoute.get(DecorItem.parameter, "category", use: getCategoryHandler)

		decorOptionItemsRoute.get(DecorItem.parameter, "builder", use: getBuilderHandler)

		decorOptionItemsRoute.get(DecorItem.parameter, "images", use: getImagesHandler)

		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = decorOptionItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(DecorItem.self, use: createHandler)
		
		tokenAuthGroup.delete(DecorItem.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(DecorItem.parameter, use: updateHandler)

		tokenAuthGroup.post(DecorItem.parameter, "image", ImageAsset.parameter, use: addImageHandler)
		
		tokenAuthGroup.delete(DecorItem.parameter, "image", ImageAsset.parameter, use: removeImageHandler)

	}
	
	
	func createHandler(_ req: Request, homeOptionItem: DecorItem) throws -> Future<DecorItem> {
		
		return homeOptionItem.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[DecorItem]>
	{
		return DecorItem.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<DecorItem>
	{
		return try req.parameters.next(DecorItem.self)
	}
	
	
	// Update passed product home option Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<DecorItem> {
		
		return try flatMap(
			to: DecorItem.self,
			req.parameters.next(DecorItem.self),
			req.content.decode(DecorItem.self)
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
		
		return try req.parameters.next(DecorItem.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the category record for this home option Item
	//
	func getCategoryHandler(_ req: Request) throws -> Future<DecorCategory> {
		
		return try req.parameters.next(DecorItem.self).flatMap(to: DecorCategory.self) { optionItem in
			
			optionItem.category.get(on: req)
		}
	}

	
	// Get the Builder record for this home option Item
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(DecorItem.self).flatMap(to: HomeBuilder.self) { homeOptionItem in
			
			homeOptionItem.builder.get(on: req)
		}
	}

	
	func addImageHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(DecorItem.self), req.parameters.next(ImageAsset.self))
		{ item, image in
			
			return item.images.attach(image, on: req).transform(to: .created)
		}
	}
	
	
	// Get the item's example images
	//
	func getImagesHandler(_ req: Request) throws -> Future<[ImageAsset]> {
		
		return try req.parameters.next(DecorItem.self).flatMap(to: [ImageAsset].self) { item in
			
			try item.images.query(on: req).all()
		}
	}
	
	
	func removeImageHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(DecorItem.self), req.parameters.next(ImageAsset.self)) { item, image in
			
			return item.images.detach(image, on: req).transform(to: .noContent)
		}
	}

	
}





