
import Vapor



struct ImageAssetController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let imageAssetsRoute = router.grouped("api", "image-asset")
		
		imageAssetsRoute.post(ImageAsset.self, use: createHandler)
		
		imageAssetsRoute.get(use: getAllHandler)
		
		imageAssetsRoute.get(ImageAsset.parameter, use: getHandler)
		
		imageAssetsRoute.put(ImageAsset.parameter, use: updateHandler)
		
		imageAssetsRoute.get(ImageAsset.parameter, "builder", use: getBuilderHandler)
		
		imageAssetsRoute.post(ImageAsset.parameter, "home-models", HomeModel.parameter, use: addHomesHandler)
		
		imageAssetsRoute.get(ImageAsset.parameter, "home-models", use: getHomesHandler)
		
		imageAssetsRoute.delete(ImageAsset.parameter, "home-models", HomeModel.parameter, 	use: removeHomesHandler)
		
		imageAssetsRoute.post(ImageAsset.parameter, "decor-items", DecorOptionItem.parameter, use: addDecorOptionsHandler)
		
		imageAssetsRoute.get(ImageAsset.parameter, "decor-items", use: getDecorOptonsHandler)
		
		imageAssetsRoute.delete(ImageAsset.parameter, "decor-items", DecorOptionItem.parameter, 	use: removeDecorOptionsHandler)
		
		imageAssetsRoute.post(ImageAsset.parameter, "home-option-items", HomeOptionItem.parameter, use: addHomeOptionsHandler)
		
		imageAssetsRoute.get(ImageAsset.parameter, "home-option-items", use: getHomeOptonsHandler)
		
		imageAssetsRoute.delete(ImageAsset.parameter, "home-option-items", HomeOptionItem.parameter, 	use: removeHomeOptionsHandler)

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
			
			imageAsset.caption = updatedImage.caption
			imageAsset.imageScale = updatedImage.imageScale
			imageAsset.assetImageType = updatedImage.assetImageType
			
			return imageAsset.save(on: req)
		}
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
	
	
	func addHomesHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
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
	
	
	func removeHomesHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(ImageAsset.self),
			req.parameters.next(HomeModel.self)
		) { imageAsset, model in
			
			return imageAsset.homeModelImages .detach(model, on: req) .transform(to: .noContent)
		}
	}
	
	
	func addDecorOptionsHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(ImageAsset.self),
			req.parameters.next(DecorOptionItem.self)) { imageAsset, decorOption in
				
				return imageAsset.decorExampleImages .attach(decorOption, on: req) .transform(to: .created)
		}
	}
	
	
	func getDecorOptonsHandler(_ req: Request ) throws -> Future<[DecorOptionItem]> {
		
		return try req.parameters.next(ImageAsset.self)
			.flatMap(to: [DecorOptionItem].self) { imageAsset in
				
				try imageAsset.decorExampleImages.query(on: req).all()
		}
	}
	
	
	func removeDecorOptionsHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(ImageAsset.self),
			req.parameters.next(DecorOptionItem.self)
		) { imageAsset, decorOption in
			
			return imageAsset.decorExampleImages .detach(decorOption, on: req) .transform(to: .noContent)
		}
	}
	
	
	func addHomeOptionsHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(ImageAsset.self),
			req.parameters.next(DecorOptionItem.self)) { imageAsset, homeOption in
				
				return imageAsset.decorExampleImages .attach(homeOption, on: req) .transform(to: .created)
		}
	}
	
	
	func getHomeOptonsHandler(_ req: Request ) throws -> Future<[HomeOptionItem]> {
		
		return try req.parameters.next(ImageAsset.self)
			.flatMap(to: [HomeOptionItem].self) { imageAsset in
				
				try imageAsset.homeOptionExampleImages.query(on: req).all()
		}
	}
	
	
	func removeHomeOptionsHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(ImageAsset.self),
			req.parameters.next(HomeOptionItem.self)
		) { imageAsset, homeOption in
			
			return imageAsset.homeOptionExampleImages .detach(homeOption, on: req) .transform(to: .noContent)
		}
	}

	
}




