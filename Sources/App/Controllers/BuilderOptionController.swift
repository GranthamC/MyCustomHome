
import Vapor
import Fluent
import Authentication



struct BuilderOptionController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionItemsRoute = router.grouped("api", "builder-option")
		
		homeOptionItemsRoute.get(use: getAllHandler)
		
		homeOptionItemsRoute.get(BuilderOption.parameter, use: getHandler)
		
		homeOptionItemsRoute.get(BuilderOption.parameter, "category", use: getCategoryHandler)

		homeOptionItemsRoute.get(BuilderOption.parameter, "builder", use: getBuilderHandler)

		homeOptionItemsRoute.get(BuilderOption.parameter, "images", use: getImagesHandler)

		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(BuilderOption.self, use: createHandler)
		
		tokenAuthGroup.delete(BuilderOption.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(BuilderOption.parameter, use: updateHandler)

		tokenAuthGroup.post(BuilderOption.parameter, "image", ImageAsset.parameter, use: addImageHandler)
		
		tokenAuthGroup.delete(BuilderOption.parameter, "image", ImageAsset.parameter, use: removeImageHandler)
	}
	
	
	func createHandler(_ req: Request, homeOptionItem: BuilderOption) throws -> Future<BuilderOption> {
		
		return homeOptionItem.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[BuilderOption]>
	{
		return BuilderOption.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<BuilderOption>
	{
		return try req.parameters.next(BuilderOption.self)
	}
	
	
	// Update passed product home option Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<BuilderOption> {
		
		return try flatMap(
			to: BuilderOption.self,
			req.parameters.next(BuilderOption.self),
			req.content.decode(BuilderOption.self)
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
		
		return try req.parameters.next(BuilderOption.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the category record for this option Item
	//
	func getCategoryHandler(_ req: Request) throws -> Future<BuilderCategory> {
		
		return try req.parameters.next(BuilderOption.self).flatMap(to: BuilderCategory.self) { optionItem in
			
			optionItem.category.get(on: req)
		}
	}

	
	// Get the Builder record for this home option Item
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(BuilderOption.self).flatMap(to: HomeBuilder.self) { homeOptionItem in
			
			homeOptionItem.builder.get(on: req)
		}
	}

	
	func addImageHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(BuilderOption.self), req.parameters.next(ImageAsset.self))
		{ item, image in
			
			return item.images.attach(image, on: req).transform(to: .created)
		}
	}
	
	
	// Get the item's example images
	//
	func getImagesHandler(_ req: Request) throws -> Future<[ImageAsset]> {
		
		return try req.parameters.next(BuilderOption.self).flatMap(to: [ImageAsset].self) { item in
			
			try item.images.query(on: req).all()
		}
	}
	
	
	func removeImageHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(BuilderOption.self), req.parameters.next(ImageAsset.self)) { item, image in
			
			return item.images.detach(image, on: req).transform(to: .noContent)
		}
	}

	
}




