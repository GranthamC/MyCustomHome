
import Vapor
import Fluent
import Authentication


struct SimApiHomeModel: Content
{
	var id: String?
	
	var modelNumber: String
	
	var modelDescription: String
	var lineID: String
	
	var plantModelID: String?
	var lineModelID: String?

	var plantID: String
	var modelID: String?
	var drawingID: String?
	var floorPlanID: String?
	
	var modelWidth: UInt16?
	var modelLength: UInt16?
	var minSquareFeet: UInt16?
	var maxSquareFeet: UInt16?
	var beds: UInt16?
	var baths: Float?
	
	var wholesalePrice: Double?
	var minGeneratedPrice: Double?
	var maxGeneratedPrice: Double?
	
	var lowHistoricalPrice: Double?
	var highHistoricalPrice: Double?
	var twoYearSalesCount: UInt16?
	
	var isMultiSection: Bool?
	var isModular: Bool?
	var isDealerEntered: Bool?
	var isBuildable: Bool?
	
	var isWebEnabled: Bool?
	
	var hasQualityPhotos: Bool?
	var hasVideo: Bool?
	var hasPhotoRealRendering: Bool?
	var isRequiringFP: Bool?
	
	var lowPrice: Double?
	var highPrice: Double?
	
	var homeImages: [SimApiImage]

	init(model: SimApiHomeModel)
	{
		self.id = model.id
		
		self.plantModelID = model.plantModelID
		self.lineModelID = model.lineModelID
		
		self.modelDescription = model.modelDescription
		self.lineID = model.lineID
		
		self.plantID = model.plantID
		self.modelNumber = model.modelNumber
		
		self.modelID = model.modelID
		self.drawingID = model.drawingID
		self.floorPlanID = model.floorPlanID
		
		self.modelWidth = model.modelWidth
		self.modelLength = model.modelLength
		self.minSquareFeet = model.minSquareFeet
		self.maxSquareFeet = model.maxSquareFeet
		self.beds = model.beds
		self.baths = model.baths
		
		self.wholesalePrice = model.wholesalePrice
		self.minGeneratedPrice = model.minGeneratedPrice
		self.maxGeneratedPrice = model.maxGeneratedPrice
		
		self.lowHistoricalPrice = model.lowHistoricalPrice
		self.highHistoricalPrice = model.highHistoricalPrice
		self.twoYearSalesCount = model.twoYearSalesCount
		
		self.isMultiSection = model.isMultiSection
		self.isModular = model.isModular
		self.isDealerEntered = model.isDealerEntered
		self.isBuildable = model.isBuildable
		
		self.isWebEnabled = model.isWebEnabled
		
		self.hasQualityPhotos = model.hasQualityPhotos
		self.hasVideo = model.hasVideo
		self.hasPhotoRealRendering = model.hasPhotoRealRendering
		self.isRequiringFP = model.isRequiringFP
		
		self.lowPrice = model.lowPrice
		self.highPrice = model.highPrice
		
		self.homeImages = model.homeImages
	}
}


struct SimApiImage: Content
{
	var id: String
	
	var imageID: String
	
	var referencePath: String
	
	var imagePath: String
	
	
	init(id: String, imageID: String, imagePath: String, referencePath: String)
	{
		self.imageID = imageID
		self.referencePath = referencePath
		self.imagePath = imagePath
		self.id = id
	}
}



struct HomeModelResponse: Content
{
	var id: String?
	
	var modelNumber: String
	
	var modelDescription: String
	var lineID: String
	
	var plantModelID: String?
	var lineModelID: String?
	
	var plantID: String
	var modelID: String?
	var drawingID: String?
	var floorPlanID: String?
	
	var modelWidth: UInt16?
	var modelLength: UInt16?
	var minSquareFeet: UInt16?
	var maxSquareFeet: UInt16?
	var beds: UInt16?
	var baths: Float?
	
	var wholesalePrice: Double?
	var minGeneratedPrice: Double?
	var maxGeneratedPrice: Double?
	
	var lowHistoricalPrice: Double?
	var highHistoricalPrice: Double?
	var twoYearSalesCount: UInt16?
	
	var isMultiSection: Bool?
	var isModular: Bool?
	var isDealerEntered: Bool?
	var isBuildable: Bool?
	
	var isWebEnabled: Bool?
	
	var hasQualityPhotos: Bool?
	var hasVideo: Bool?
	var hasPhotoRealRendering: Bool?
	var isRequiringFP: Bool?
	
	var lowPrice: Double?
	var highPrice: Double?
	
	var homeImages: [SimApiImage]

	var builderOptions: [BuilderOptionResponse]
	
	var decorOptions: [DecorOptionResponse]
	
	var modelOptions: [ModelOptionResponse]
	
	init(model: SimApiHomeModel, options: HomeModelOptionsResponse)
	{
		self.id = model.id
		
		self.plantModelID = model.plantModelID
		self.lineModelID = model.lineModelID
		
		self.modelDescription = model.modelDescription
		self.lineID = model.lineID
		
		self.plantID = model.plantID
		self.modelNumber = model.modelNumber
		
		self.modelID = model.modelID
		self.drawingID = model.drawingID
		self.floorPlanID = model.floorPlanID
		
		self.modelWidth = model.modelWidth
		self.modelLength = model.modelLength
		self.minSquareFeet = model.minSquareFeet
		self.maxSquareFeet = model.maxSquareFeet
		self.beds = model.beds
		self.baths = model.baths
		
		self.wholesalePrice = model.wholesalePrice
		self.minGeneratedPrice = model.minGeneratedPrice
		self.maxGeneratedPrice = model.maxGeneratedPrice
		
		self.lowHistoricalPrice = model.lowHistoricalPrice
		self.highHistoricalPrice = model.highHistoricalPrice
		self.twoYearSalesCount = model.twoYearSalesCount
		
		self.isMultiSection = model.isMultiSection
		self.isModular = model.isModular
		self.isDealerEntered = model.isDealerEntered
		self.isBuildable = model.isBuildable
		
		self.isWebEnabled = model.isWebEnabled
		
		self.hasQualityPhotos = model.hasQualityPhotos
		self.hasVideo = model.hasVideo
		self.hasPhotoRealRendering = model.hasPhotoRealRendering
		self.isRequiringFP = model.isRequiringFP
		
		self.lowPrice = model.lowPrice
		self.highPrice = model.highPrice
		
		self.homeImages = model.homeImages
		
		self.builderOptions = options.builderOptions
		
		self.decorOptions = options.decorOptions
		
		self.modelOptions = options.modelOptions
		
	}
}


struct HomeModelOptionsResponse: Content
{
	var builderOptions: [BuilderOptionResponse]
	
	var decorOptions: [DecorOptionResponse]
	
	var modelOptions: [ModelOptionResponse]
	
	init(builderOptions: [BuilderOptionResponse], decorOptions: [DecorOptionResponse], modelOptions: [ModelOptionResponse])
	{
		self.builderOptions = builderOptions
		
		self.decorOptions = decorOptions
		
		self.modelOptions = modelOptions
	}
}


struct BuilderOptionResponse: Content
{
	var category: String
	var categoryID: String
	var optionType: Int32?
	
	var categoryOptions: [BuilderOption]
	
	init(category: HM_BdrOptCategory, homeOptions: [BuilderOption])
	{
		self.category = category.name
		self.categoryID = category.categoryID.uuidString
		self.optionType = category.optionType
		
		self.categoryOptions = homeOptions
	}
}


struct DecorOptionResponse: Content
{
	var category: String
	var categoryID: String
	var optionType: Int32?
	
	var categoryOptions: [DecorItem]
	
	init(category: HM_DecorCategory, homeOptions: [DecorItem])
	{
		self.category = category.name
		self.categoryID = category.categoryID.uuidString
		self.optionType = category.optionType
		
		self.categoryOptions = homeOptions
	}
}


struct ModelOptionResponse: Content
{
	var category: String
	var categoryID: String
	var optionType: Int32?
	
	var categoryOptions: [DecorItem]
	
	init(category: HM_DecorCategory, homeOptions: [DecorItem])
	{
		self.category = category.name
		self.categoryID = category.categoryID.uuidString
		self.optionType = category.optionType
		
		self.categoryOptions = homeOptions
	}
}



struct HomeModelController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeModelsRoute = router.grouped("api", "home-model")
		
		homeModelsRoute.get(use: getAllHandler)
		
		homeModelsRoute.get("model-options", String.parameter, use: getModelNumberHandler)
		
		homeModelsRoute.get("model-number", String.parameter, use: getSimModelHandler)
		
		homeModelsRoute.get("model-data", String.parameter, use: getModelInfoHandler)

		homeModelsRoute.get(HomeModel.parameter, use: getHandler)

		homeModelsRoute.get("search", use: searchHandler)
		
		homeModelsRoute.get("first", use: getFirstHandler)
		
		homeModelsRoute.get("sorted", use: sortedHandler)

		homeModelsRoute.get(HomeModel.parameter, "line", use: getProductLineHandler)

		homeModelsRoute.get(HomeModel.parameter, "decor-categories", use: getDecorCategoryHandler)

		homeModelsRoute.get(HomeModel.parameter, "builder-option-categories", use: getBuilderOptionCategoryHandler)
		
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

		tokenAuthGroup.post(HomeModel.parameter, "image", Image.parameter, use: addImageHandler)
		
		tokenAuthGroup.delete(HomeModel.parameter, "image", Image.parameter, use: removeImageHandler)
	}
	
	
	func createHandler(_ req: Request, model: HomeModel) throws -> Future<HomeModel> {
		
		return model.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[HomeModel]>
	{
		return HomeModel.query(on: req).all()
	}
	
	
	func getSimModelHandler(_ req: Request) throws -> Future<HomeModelResponse>
	{
		let modelNumber = try req.parameters.next(String.self)
		
		let resUrl = "https://sc-simapi.vapor.cloud/api/home-model/model-number/" + modelNumber.uppercased()
		
		let simResponse = try req.client().get(resUrl)
		
		let simModel = simResponse.flatMap { homeModel -> Future<HomeModelResponse> in
			
			let modelInfo = try homeModel.content.decode(SimApiHomeModel.self)
			
			let modelOptions = try self.getHomeModelOptions(req, modelNumber: modelNumber)
			
//			let modelOptions = try self.getHomeModelOptions(req, modelNumber: modelNumber).catchFlatMap(<#T##callback: (Error) throws -> (EventLoopFuture<HomeModelOptionsResponse>)##(Error) throws -> (EventLoopFuture<HomeModelOptionsResponse>)#>)

			let modelResponse = modelInfo.map({ model -> Future<HomeModelResponse> in
				
				let modelOptionsResponse = modelOptions.map { options -> HomeModelResponse in
					
					return HomeModelResponse(model: model, options: options)
				}
				
				return modelOptionsResponse.map(to: HomeModelResponse.self) { allResponses -> HomeModelResponse in
					
					return allResponses
				}
			})
			
			return modelResponse.flatMap { returnModel -> Future<HomeModelResponse> in
				
				return returnModel
			}

		}
		
		return simModel
	}
	
	
	
	func getHomeModelOptions(_ req: Request, modelNumber: String) throws -> Future<HomeModelOptionsResponse>
	{
		return HomeModel.query(on: req).group(.or) { or in
			
			or.filter(\.modelNumber == modelNumber.uppercased())
			}.first().flatMap(to: HomeModelOptionsResponse.self) { homemodel in
				
				guard let decorCategories = try homemodel?.decorCategories.query(on: req).all() else {
					throw Abort(.notFound)
				}
				
				let decorResponses = try self.getDecorItemsResponses(req, decorCategories: decorCategories)
				
				let homeResponse = decorResponses.map { decorOptions -> Future<HomeModelOptionsResponse> in
					
					guard let builderOptionCategories = try homemodel?.builderOptionCategories.query(on: req).all() else {
						throw Abort(.notFound)
					}
					
					let builderOptionResponses = try self.getBuilderOptionItemsResponses(req, builderOptionCategories: builderOptionCategories)
					
					let builderOptResponse = builderOptionResponses.map { builderOptions -> Future<HomeModelOptionsResponse> in
						
						let homeImages = try self.getHomeImages(req, home: homemodel!)
						
						let modelResponse = homeImages.map { ssImages in
							
							return HomeModelOptionsResponse(builderOptions: builderOptions, decorOptions: decorOptions, modelOptions: [])
						}
						
						return modelResponse
					}
					
					return builderOptResponse.flatMap(to: HomeModelOptionsResponse.self) { allResponses in
						
						return allResponses
					}
				}
				
				return homeResponse.flatMap(to: HomeModelOptionsResponse.self) { allResponses in
					
					return allResponses
				}
		}
	}
	
	
	func getModelInfoHandler(_ req: Request) throws -> Future<SimApiHomeModel>
	{
		let modelNumber = try req.parameters.next(String.self)
		
		let resUrl = "https://sc-simapi.vapor.cloud/api/home-model/model-number/" + modelNumber.uppercased()
		
		let simResponse = try req.client().get(resUrl)
		
		let simModel = simResponse.flatMap { homeModel -> Future<SimApiHomeModel> in
			
			let modelInfo = try homeModel.content.decode(SimApiHomeModel.self)
			
			return modelInfo
		}
		
		return simModel
	}

	
	
	func getModelNumberHandler(_ req: Request) throws -> Future<HomeModelOptionsResponse>
	{
		let modelNumber = try req.parameters.next(String.self)
		
		return HomeModel.query(on: req).group(.or) { or in
			
			or.filter(\.modelNumber == modelNumber.uppercased())
			}.first().flatMap(to: HomeModelOptionsResponse.self) { homemodel in
				
				guard let decorCategories = try homemodel?.decorCategories.query(on: req).all() else {
					throw Abort(.notFound)
				}
				
				let decorResponses = try self.getDecorItemsResponses(req, decorCategories: decorCategories)
				
				let homeResponse = decorResponses.map { decorOptions -> Future<HomeModelOptionsResponse> in
					
					guard let builderOptionCategories = try homemodel?.builderOptionCategories.query(on: req).all() else {
						throw Abort(.notFound)
					}
					
					let builderOptionResponses = try self.getBuilderOptionItemsResponses(req, builderOptionCategories: builderOptionCategories)
					
					let builderOptResponse = builderOptionResponses.map { builderOptions -> Future<HomeModelOptionsResponse> in
						
						let homeImages = try self.getHomeImages(req, home: homemodel!)
						
						let modelResponse = homeImages.map { ssImages in
							
							return HomeModelOptionsResponse(builderOptions: builderOptions, decorOptions: decorOptions, modelOptions: [])
						}
						
						return modelResponse
					}
					
					return builderOptResponse.flatMap(to: HomeModelOptionsResponse.self) { allResponses in
						
						return allResponses
					}
				}
				
				return homeResponse.flatMap(to: HomeModelOptionsResponse.self) { allResponses in
					
					return allResponses
				}
		}
	}

	
	func getDecorItemsResponses(_ request: Request, decorCategories: Future<[HM_DecorCategory]>) throws -> Future<[DecorOptionResponse]> {
		
		return decorCategories.flatMap { categories in
			
			let catResponseFutures = try categories.map { category in
				
				try category.optionItems.query(on: request).all().map { items in
					return DecorOptionResponse(category: category, homeOptions: items)
				}
			}
			
			return catResponseFutures.flatten(on: request)
		}
	}

	
	func getBuilderOptionItemsResponses(_ request: Request, builderOptionCategories: Future<[HM_BdrOptCategory]>) throws -> Future<[BuilderOptionResponse]> {
		
		return builderOptionCategories.flatMap { categories in
			
			let catResponseFutures = try categories.map { category in
				
				try category.optionItems.query(on: request).all().map { items in
					return BuilderOptionResponse(category: category, homeOptions: items)
				}
			}
			
			return catResponseFutures.flatten(on: request)
		}
	}

	
	func getHandler(_ req: Request) throws -> Future<HomeModel>
	{
		return try req.parameters.next(HomeModel.self)
	}
	
	
	func searchHandler(_ req: Request) throws -> Future<[HomeModel]>
	{
		guard let searchTerm = req.query[String.self, at: "param"] else {
			throw Abort(.badRequest)
		}
		
		return HomeModel.query(on: req).group(.or) { or in
			or.filter(\.lineID == searchTerm)
			or.filter(\.plantID == searchTerm)
			or.filter(\.modelID == searchTerm)
			or.filter(\.modelNumber == searchTerm)
			}.all()
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
			model.plantModelID = updatedModel.plantModelID
			model.changeToken = updatedModel.changeToken

			model.heroImageURL = updatedModel.heroImageURL
			model.floorPlanURL = updatedModel.floorPlanURL
			model.exteriorImageURL = updatedModel.exteriorImageURL
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

			model.modelID = updatedModel.modelID
			model.modelDescription = updatedModel.modelDescription
			model.lineID = updatedModel.lineID
			model.plantID = updatedModel.plantID

			return model.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HomeModel.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}

/*
	func searchHandler(_ req: Request) throws -> Future<HomeModelResponse>
	{
		guard let searchTerm = req.query[String.self, at: "model"] else {
			throw Abort(.badRequest)
		}
		
		return HomeModel.query(on: req).group(.or) { or in
			or.filter(\.name == searchTerm)
			or.filter(\.modelNumber == searchTerm)
			}.first().flatMap(to: HomeModelResponse.self) { homemodel in
				
				let optionCats = try homemodel?.decorCategories.query(on: req).all()
				
				let optionResponses = try self.allCatResponses(req, optionCats: optionCats!)
				
				let homeResponse = optionResponses.map { responses -> Future<HomeModelResponse> in
					
					let homeImages = try self.getHomeImages(req, home: homemodel!)
					
					let imageResponse = homeImages.map { ssImages in
						
//						return HomeModelResponse(model: homemodel!, homeOptions: responses, images: ssImages)
						return HomeModelResponse(model: homemodel!, homeOptions: responses, decorOptions: responses, modelOptions: responses, images: ssImages)
					}
					
					return imageResponse
				}
				
				return homeResponse.flatMap(to: HomeModelResponse.self) { allResponses in
					
					return allResponses
				}
		}
	}
*/
	
	// Get the line's home models
	//
	func getHomeImages(_ req: Request, home: HomeModel) throws -> Future<[Image]> {
		
		return try home.images.query(on: req).all()
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
	func getProductLineHandler(_ req: Request) throws -> Future<Line> {
		
		return try req
			.parameters.next(HomeModel.self)
			.flatMap(to: Line.self) { model in
				
				model.productLine.get(on: req)
		}
	}

	
	
	// Get the home's decor option categories
	//
	func getDecorCategoryHandler(_ req: Request) throws -> Future<[HM_DecorCategory]> {
		
		return try req.parameters.next(HomeModel.self).flatMap(to: [HM_DecorCategory].self) { model in
			
			try model.decorCategories.query(on: req).all()
		}
	}
	
	
	// Get the home's builder option categories
	//
	func getBuilderOptionCategoryHandler(_ req: Request) throws -> Future<[HM_BdrOptCategory]> {
		
		return try req.parameters.next(HomeModel.self).flatMap(to: [HM_BdrOptCategory].self) { model in
			
			try model.builderOptionCategories.query(on: req).all()
		}
	}

	
	func addImageHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(HomeModel.self), req.parameters.next(Image.self))
		{ model, image in
			
			return model.images.attach(image, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getImagesHandler(_ req: Request) throws -> Future<[Image]> {
		
		return try req.parameters.next(HomeModel.self).flatMap(to: [Image].self) { model in
			
			try model.images.query(on: req).all()
		}
	}
	
	func removeImageHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(HomeModel.self), req.parameters.next(Image.self)) { model, image in
			
			return model.images.detach(image, on: req).transform(to: .noContent)
		}
	}
}


