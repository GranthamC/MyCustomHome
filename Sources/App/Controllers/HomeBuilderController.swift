import Vapor
import Fluent
import Authentication



struct HomeBuilderController: RouteCollection
{

	func boot(router: Router) throws {

		let buildersRoute = router.grouped("api", "plant")
		
		buildersRoute.get(use: getAllHandler)

		buildersRoute.get(Plant.parameter, use: getHandler)
		
		buildersRoute.get("search", use: searchHandler)

		buildersRoute.get("first", use: getFirstHandler)

		buildersRoute.get("sorted", use: sortedHandler)
		
		buildersRoute.get(Plant.parameter, "lines", use: getProductLinesHandler)
		
		buildersRoute.get(Plant.parameter, "plant-option-categories", use: getHomeOptionCategoriesHandler)
		
		buildersRoute.get(Plant.parameter, "plant-option-items", use: getHomeOptionItemsHandler)
		
		buildersRoute.get(Plant.parameter, "decor-categories", use: getDecorOptionCategoriesHandler)
		
		buildersRoute.get(Plant.parameter, "decor-items", use: getDecorOptionItemsHandler)

		buildersRoute.get(Plant.parameter, "images", use: getImagesHandler)
		
		buildersRoute.get(Plant.parameter, "decor-packages", use: getDecorPackagesHandler)
		
		buildersRoute.get(Plant.parameter, "home-models", use: getHomeModelsHandler)

		buildersRoute.get(Plant.parameter, "change-tokens", use: getTokensHandler)

		buildersRoute.get(Plant.parameter, "home-sets", use: getHomeSetsHandler)


		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()

		let tokenAuthGroup = buildersRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)

		tokenAuthGroup.post(Plant.self, use: createHandler)
		
		tokenAuthGroup.delete(Plant.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(Plant.parameter, use: updateHandler)

	}

	
	func createHandler(_ req: Request, builder: Plant) throws -> Future<Plant> {
		
		return builder.save(on: req)
	}

	
	func getAllHandler(_ req: Request) throws -> Future<[Plant]>
	{
		return Plant.query(on: req).all()
	}
	

	func getHandler(_ req: Request) throws -> Future<Plant>
	{
		return try req.parameters.next(Plant.self)
	}
	
	// Update passed builder with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<Plant> {
		
		return try flatMap(
			to: Plant.self,
			req.parameters.next(Plant.self),
			req.content.decode(Plant.self)
		) { builder, updatedBuilder in
			builder.name = updatedBuilder.name
			builder.plantName = updatedBuilder.plantName
			builder.plantID = updatedBuilder.plantID
			builder.plantNumber = updatedBuilder.plantNumber
			builder.logoURL = updatedBuilder.logoURL
			builder.websiteURL = updatedBuilder.websiteURL
			builder.changeToken = updatedBuilder.changeToken

			// Get the authenticated user who is making this change
			//
//			let user = try req.requireAuthenticated(User.self)
			
//			builder.userUpdateID = try user.requireID()

			return builder.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(Plant.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}

	
	func searchHandler(_ req: Request) throws -> Future<[Plant]>
	{
		guard let searchTerm = req.query[String.self, at: "param"] else {
			throw Abort(.badRequest)
		}
		
		return Plant.query(on: req).group(.or) { or in
			or.filter(\.name == searchTerm)
			or.filter(\.plantNumber == searchTerm)
			}.all()
	}

	
	func getFirstHandler(_ req: Request) throws -> Future<Plant>
	{
		return Plant.query(on: req)
			.first()
			
			.map(to: Plant.self) { homebuilder in
				guard let homebuilder = homebuilder else {
					throw Abort(.notFound)
				}
				
				return homebuilder
		}
	}
	
	
	func sortedHandler(_ req: Request) throws -> Future<[Plant]>
	{
		return Plant.query(on: req).sort(\.name, .ascending).all()
	}
	
	
	// Get the builder's product lines
	//
	func getProductLinesHandler(_ req: Request) throws -> Future<[Line]> {
		
		return try req
			.parameters.next(Plant.self)
			.flatMap(to: [Line].self) { builder in
				
				try builder.productLines.query(on: req).all()
		}
	}
	
	
	// Get the builder's home option categories
	//
	func getHomeOptionCategoriesHandler(_ req: Request) throws -> Future<[PlantCategory]> {
		
		return try req
			.parameters.next(Plant.self)
			.flatMap(to: [PlantCategory].self) { builder in
				
				try builder.homeOptionCategories.query(on: req).all()
		}
	}

	
	// Get the builder's home options
	//
	func getHomeOptionItemsHandler(_ req: Request) throws -> Future<[BuilderOption]> {
		
		return try req
			.parameters.next(Plant.self)
			.flatMap(to: [BuilderOption].self) { builder in
				
				try builder.homeOptions.query(on: req).all()
		}
	}
	
	
	// Get the builder's home option categories
	//
	func getDecorOptionCategoriesHandler(_ req: Request) throws -> Future<[DecorCategory]> {
		
		return try req
			.parameters.next(Plant.self)
			.flatMap(to: [DecorCategory].self) { builder in
				
				try builder.decorOptionCategories.query(on: req).all()
		}
	}
	
	
	// Get the builder's home options
	//
	func getDecorOptionItemsHandler(_ req: Request) throws -> Future<[DecorItem]> {
		
		return try req
			.parameters.next(Plant.self)
			.flatMap(to: [DecorItem].self) { builder in
				
				try builder.decorOptions.query(on: req).all()
		}
	}

	
	// Get the builder's image assets
	//
	func getImagesHandler(_ req: Request) throws -> Future<[Image]> {
		
		return try req
			.parameters.next(Plant.self)
			.flatMap(to: [Image].self) { builder in
				
				try builder.images.query(on: req).all()
		}
	}

	
	// Get the builder's image assets
	//
	func getDecorPackagesHandler(_ req: Request) throws -> Future<[DecorPackage]> {
		
		return try req
			.parameters.next(Plant.self)
			.flatMap(to: [DecorPackage].self) { builder in
				
				try builder.decorPackages.query(on: req).all()
		}
	}

	
	// Get the builder's home models
	//
	func getHomeModelsHandler(_ req: Request) throws -> Future<[HomeModel]> {
		
		return try req
			.parameters.next(Plant.self)
			.flatMap(to: [HomeModel].self) { builder in
				
				try builder.homeModels.query(on: req).all()
		}
	}

	
	// Get the builder's home sets
	//
	func getHomeSetsHandler(_ req: Request) throws -> Future<[HomeModelSet]> {
		
		return try req
			.parameters.next(Plant.self)
			.flatMap(to: [HomeModelSet].self) { builder in
				
				try builder.homeSets.query(on: req).all()
		}
	}

	
	// Get the change tokens for this builder
	//
	func getTokensHandler(_ req: Request) throws -> Future<ChangeToken> {
		
		return try req.parameters.next(Plant.self).flatMap(to: ChangeToken.self) { builder in
			
			builder.changeTokens.get(on: req)
		}
	}

}

