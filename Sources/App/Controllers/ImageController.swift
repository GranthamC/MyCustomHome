
import Vapor
import Fluent
import Authentication


struct ImageController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let imageAssetsRoute = router.grouped("api", "image")
		
//		imageAssetsRoute.post(ImageAsset.self, use: createHandler)
		
		imageAssetsRoute.get(use: getAllHandler)
		
		imageAssetsRoute.get(Image.parameter, use: getHandler)
		
//		imageAssetsRoute.put(ImageAsset.parameter, use: updateHandler)

//		imageAssetsRoute.delete(ImageAsset.parameter, use: deleteHandler)

		imageAssetsRoute.get(Image.parameter, "plant", use: getBuilderHandler)
		
		imageAssetsRoute.get(Image.parameter, "home-models", use: getHomesHandler)
		
		imageAssetsRoute.get(Image.parameter, "home-option-items", use: getHomeOptonsHandler)
		
		imageAssetsRoute.get(Image.parameter, "decor-items", use: getDecorOptonsHandler)

		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = imageAssetsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(Image.self, use: createHandler)
		
		tokenAuthGroup.delete(Image.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(Image.parameter, use: updateHandler)

		tokenAuthGroup.post(Image.parameter, "home-model", HomeModel.parameter, use: addHomeHandler)
		
		tokenAuthGroup.delete(Image.parameter, "home-model", HomeModel.parameter, 	use: removeHomeHandler)

		tokenAuthGroup.delete(Image.parameter, "home-option-item", BuilderOption.parameter, 	use: removeHomeOptionHandler)

		tokenAuthGroup.delete(Image.parameter, "decor-item", DecorItem.parameter, 	use: removeDecorOptionHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		imageAsset: Image
		) throws -> Future<Image> {
		
		return imageAsset.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[Image]>
	{
		return Image.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<Image>
	{
		return try req.parameters.next(Image.self)
	}
	
	
	// Update passed product home option Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<Image> {
		
		return try flatMap(
			to: Image.self,
			req.parameters.next(Image.self),
			req.content.decode(Image.self)
		) {
			imageAsset, updatedImage in
			
			imageAsset.imageURL = updatedImage.imageURL
			imageAsset.plantID = updatedImage.plantID
			imageAsset.changeToken = updatedImage.changeToken

			imageAsset.caption = updatedImage.caption
			imageAsset.imageScale = updatedImage.imageScale
			imageAsset.imageType = updatedImage.imageType
			
			return imageAsset.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(Image.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	

	// Get the Builder record for this home option Item
	//
	func getBuilderHandler(_ req: Request) throws -> Future<Plant> {
		
		return try req
			.parameters.next(Image.self)
			.flatMap(to: Plant.self) { imageAsset in
				
				imageAsset.builder.get(on: req)
		}
	}
	
	
	func addHomeHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(Image.self),
			req.parameters.next(HomeModel.self)) { imageAsset, model in
				
				return imageAsset.homeModelImages .attach(model, on: req) .transform(to: .created)
		}
	}
	
	
	func getHomesHandler(_ req: Request ) throws -> Future<[HomeModel]> {
		
		return try req.parameters.next(Image.self)
			.flatMap(to: [HomeModel].self) { imageAsset in
				
				try imageAsset.homeModelImages.query(on: req).all()
		}
	}
	
	
	func removeHomeHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(Image.self),
			req.parameters.next(HomeModel.self)
		) { imageAsset, model in
			
			return imageAsset.homeModelImages .detach(model, on: req) .transform(to: .noContent)
		}
	}
	
	
	func getHomeOptonsHandler(_ req: Request ) throws -> Future<[BuilderOption]> {
		
		return try req.parameters.next(Image.self)
			.flatMap(to: [BuilderOption].self) { imageAsset in
				
				try imageAsset.homeOptionExampleImages.query(on: req).all()
		}
	}
	
	
	func removeHomeOptionHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(Image.self),
			req.parameters.next(BuilderOption.self)
		) { imageAsset, homeOption in
			
			return imageAsset.homeOptionExampleImages .detach(homeOption, on: req) .transform(to: .noContent)
		}
	}
	
	
	func getDecorOptonsHandler(_ req: Request ) throws -> Future<[DecorItem]> {
		
		return try req.parameters.next(Image.self)
			.flatMap(to: [DecorItem].self) { imageAsset in
				
				try imageAsset.decorOptionImages.query(on: req).all()
		}
	}
	
	
	func removeDecorOptionHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(Image.self),
			req.parameters.next(DecorItem.self)
		) { imageAsset, homeOption in
			
			return imageAsset.decorOptionImages .detach(homeOption, on: req) .transform(to: .noContent)
		}
	}

	
}





