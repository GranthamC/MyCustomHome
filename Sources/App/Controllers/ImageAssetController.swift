
import Vapor
import Fluent
import Authentication


struct ImageAssetController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let imageAssetsRoute = router.grouped("api", "image-asset")
		
//		imageAssetsRoute.post(ImageAsset.self, use: createHandler)
		
		imageAssetsRoute.get(use: getAllHandler)
		
		imageAssetsRoute.get(ImageAsset.parameter, use: getHandler)
		
//		imageAssetsRoute.put(ImageAsset.parameter, use: updateHandler)

//		imageAssetsRoute.delete(ImageAsset.parameter, use: deleteHandler)

		imageAssetsRoute.get(ImageAsset.parameter, "builder", use: getBuilderHandler)
		
		imageAssetsRoute.get(ImageAsset.parameter, "home-models", use: getHomesHandler)
		
		imageAssetsRoute.get(ImageAsset.parameter, "home-option-items", use: getHomeOptonsHandler)
		
		imageAssetsRoute.get(ImageAsset.parameter, "decor-items", use: getDecorOptonsHandler)

		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = imageAssetsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(ImageAsset.self, use: createHandler)
		
		tokenAuthGroup.delete(ImageAsset.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(ImageAsset.parameter, use: updateHandler)

		tokenAuthGroup.post(ImageAsset.parameter, "home-model", HomeModel.parameter, use: addHomeHandler)
		
		tokenAuthGroup.delete(ImageAsset.parameter, "home-model", HomeModel.parameter, 	use: removeHomeHandler)

		tokenAuthGroup.delete(ImageAsset.parameter, "home-option-item", BuilderOptionItem.parameter, 	use: removeHomeOptionHandler)

		tokenAuthGroup.delete(ImageAsset.parameter, "decor-item", DecorItem.parameter, 	use: removeDecorOptionHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		imageAsset: ImageAsset
		) throws -> Future<ImageAsset> {
		
		return imageAsset.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[ImageAsset]>
	{
		return ImageAsset.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<ImageAsset>
	{
		return try req.parameters.next(ImageAsset.self)
	}
	
	
	// Update passed product home option Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<ImageAsset> {
		
		return try flatMap(
			to: ImageAsset.self,
			req.parameters.next(ImageAsset.self),
			req.content.decode(ImageAsset.self)
		) {
			imageAsset, updatedImage in
			
			imageAsset.assetImageURL = updatedImage.assetImageURL
			imageAsset.builderID = updatedImage.builderID
			imageAsset.changeToken = updatedImage.changeToken

			imageAsset.caption = updatedImage.caption
			imageAsset.imageScale = updatedImage.imageScale
			imageAsset.assetImageType = updatedImage.assetImageType
			
			return imageAsset.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(ImageAsset.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	

	// Get the Builder record for this home option Item
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req
			.parameters.next(ImageAsset.self)
			.flatMap(to: HomeBuilder.self) { imageAsset in
				
				imageAsset.builder.get(on: req)
		}
	}
	
	
	func addHomeHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(ImageAsset.self),
			req.parameters.next(HomeModel.self)) { imageAsset, model in
				
				return imageAsset.homeModelImages .attach(model, on: req) .transform(to: .created)
		}
	}
	
	
	func getHomesHandler(_ req: Request ) throws -> Future<[HomeModel]> {
		
		return try req.parameters.next(ImageAsset.self)
			.flatMap(to: [HomeModel].self) { imageAsset in
				
				try imageAsset.homeModelImages.query(on: req).all()
		}
	}
	
	
	func removeHomeHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(ImageAsset.self),
			req.parameters.next(HomeModel.self)
		) { imageAsset, model in
			
			return imageAsset.homeModelImages .detach(model, on: req) .transform(to: .noContent)
		}
	}
	
	
	func getHomeOptonsHandler(_ req: Request ) throws -> Future<[BuilderOptionItem]> {
		
		return try req.parameters.next(ImageAsset.self)
			.flatMap(to: [BuilderOptionItem].self) { imageAsset in
				
				try imageAsset.homeOptionExampleImages.query(on: req).all()
		}
	}
	
	
	func removeHomeOptionHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(ImageAsset.self),
			req.parameters.next(BuilderOptionItem.self)
		) { imageAsset, homeOption in
			
			return imageAsset.homeOptionExampleImages .detach(homeOption, on: req) .transform(to: .noContent)
		}
	}
	
	
	func getDecorOptonsHandler(_ req: Request ) throws -> Future<[DecorItem]> {
		
		return try req.parameters.next(ImageAsset.self)
			.flatMap(to: [DecorItem].self) { imageAsset in
				
				try imageAsset.decorOptionImages.query(on: req).all()
		}
	}
	
	
	func removeDecorOptionHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(ImageAsset.self),
			req.parameters.next(DecorItem.self)
		) { imageAsset, homeOption in
			
			return imageAsset.decorOptionImages .detach(homeOption, on: req) .transform(to: .noContent)
		}
	}

	
}





