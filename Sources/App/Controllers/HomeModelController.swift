
import Vapor
import Fluent
import Authentication


struct HomeModelController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeModelsRoute = router.grouped("api", "home-model")
		
		homeModelsRoute.get(use: getAllHandler)
		
		homeModelsRoute.get(HomeModel.parameter, use: getHandler)
		
		homeModelsRoute.get("search", use: searchHandler)
		
		homeModelsRoute.get("first", use: getFirstHandler)
		
		homeModelsRoute.get("sorted", use: sortedHandler)

		homeModelsRoute.get(HomeModel.parameter, "line", use: getProductLineHandler)
		
		homeModelsRoute.get(HomeModel.parameter, "option-categories", use: getOptionCategoryHandler)
		
		homeModelsRoute.get(HomeModel.parameter, "option-items", use: getOptionItemHandler)
		
		homeModelsRoute.get(HomeModel.parameter, "images", use: getImagesHandler)

		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeModelsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(HomeModel.self, use: createHandler)
		
		tokenAuthGroup.delete(HomeModel.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HomeModel.parameter, use: updateHandler)
		
		tokenAuthGroup.post(HomeModel.parameter, "option-category", HomeOptionCategory.parameter, use: addOptionCategoryHandler)
		
		tokenAuthGroup.delete(HomeModel.parameter, "option-category", HomeOptionCategory.parameter, use: removeOptionCategoryHandler)
		
		tokenAuthGroup.post(HomeModel.parameter, "option-item", HomeOptionItem.parameter, use: addOptionItemHandler)
		
		tokenAuthGroup.delete(HomeModel.parameter, "option-item", HomeOptionItem.parameter, use: removeOptionItemHandler)
		
		tokenAuthGroup.post(HomeModel.parameter, "image", ImageAsset.parameter, use: addImageHandler)
		
		tokenAuthGroup.delete(HomeModel.parameter, "image", ImageAsset.parameter, use: removeImageHandler)

	}
	
	
	func createHandler(_ req: Request, model: HomeModel) throws -> Future<HomeModel> {
		
		return model.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[HomeModel]>
	{
		return HomeModel.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<HomeModel>
	{
		return try req.parameters.next(HomeModel.self)
	}
	
	
	// Update passed home model with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HomeModel> {
		
		return try flatMap(
			to: HomeModel.self,
			req.parameters.next(HomeModel.self),
			req.content.decode(HomeModel.self)
		) { model, updatedModel in
			
			model.name = updatedModel.name
			model.modelNumber = updatedModel.modelNumber
			model.builderID = updatedModel.builderID
			
			model.heroImageURL = updatedModel.heroImageURL
			model.matterportTourURL = updatedModel.matterportTourURL
			model.panoModelTourURL = updatedModel.panoModelTourURL

			model.sqft = updatedModel.sqft
			model.baths = updatedModel.baths
			model.beds = updatedModel.beds
			model.features = updatedModel.features
			model.priceBase = updatedModel.priceBase
			model.priceUpper = updatedModel.priceUpper

			model.isEnabled = updatedModel.isEnabled
			model.isSingleSection = updatedModel.isSingleSection

			model.hasBasement = updatedModel.hasBasement
			model.sqftBasement = updatedModel.sqftBasement
			model.sqftMain = updatedModel.sqftMain
			model.sqftUpper = updatedModel.sqftUpper

			return model.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HomeModel.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}
	
	
	func searchHandler(_ req: Request) throws -> Future<[HomeModel]>
	{
		guard let searchTerm = req.query[String.self, at: "param"] else {
			throw Abort(.badRequest)
		}
		
		return HomeModel.query(on: req).group(.or) { or in
			or.filter(\.name == searchTerm)
			or.filter(\.modelNumber == searchTerm)
			}.all()
	}
	
	
	func getFirstHandler(_ req: Request) throws -> Future<HomeModel>
	{
		return HomeModel.query(on: req)
			.first()
			
			.map(to: HomeModel.self) { homemodel in
				guard let model = homemodel else {
					throw Abort(.notFound)
				}
				
				return model
		}
	}
	
	
	func sortedHandler(_ req: Request) throws -> Future<[HomeModel]>
	{
		return HomeModel.query(on: req).sort(\.name, .ascending).all()
	}
	
	

	// Get the Product line record for this home model
	//
	func getProductLineHandler(_ req: Request) throws -> Future<[ProductLine]> {
		
		return try req
			.parameters.next(HomeModel.self)
			.flatMap(to: [ProductLine].self) { home in
				
				try home.productLines.query(on: req).all()
		}
	}

	
	
	
	func addOptionCategoryHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(HomeModel.self), req.parameters.next(HomeOptionCategory.self))
		{ model, category in
			
			return model.optionCategories.attach(category, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionCategoryHandler(_ req: Request) throws -> Future<[HomeOptionCategory]> {
		
		return try req.parameters.next(HomeModel.self).flatMap(to: [HomeOptionCategory].self) { model in
			
			try model.optionCategories.query(on: req).all()
		}
	}
	
	func removeOptionCategoryHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(HomeModel.self), req.parameters.next(HomeOptionCategory.self)) { model, category in
			
			return model.optionCategories.detach(category, on: req).transform(to: .noContent)
		}
	}
	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(HomeModel.self), req.parameters.next(HomeOptionItem.self))
		{ model, item in
			
			return model.optionItems.attach(item, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[HomeOptionItem]> {
		
		return try req.parameters.next(HomeModel.self).flatMap(to: [HomeOptionItem].self) { model in
			
			try model.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(HomeModel.self), req.parameters.next(HomeOptionItem.self)) { model, item in
			
			return model.optionItems.detach(item, on: req).transform(to: .noContent)
		}
	}

	
	func addImageHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(HomeModel.self), req.parameters.next(ImageAsset.self))
		{ model, image in
			
			return model.images.attach(image, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getImagesHandler(_ req: Request) throws -> Future<[ImageAsset]> {
		
		return try req.parameters.next(HomeModel.self).flatMap(to: [ImageAsset].self) { model in
			
			try model.images.query(on: req).all()
		}
	}
	
	func removeImageHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(HomeModel.self), req.parameters.next(ImageAsset.self)) { model, image in
			
			return model.images.detach(image, on: req).transform(to: .noContent)
		}
	}
}


