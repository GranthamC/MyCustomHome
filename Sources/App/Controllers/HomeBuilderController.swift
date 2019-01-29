import Vapor
import Fluent
import Authentication



struct HomeBuilderController: RouteCollection
{

	func boot(router: Router) throws {

		let buildersRoute = router.grouped("api", "builder")
		
		buildersRoute.get(use: getAllHandler)

		buildersRoute.get(HomeBuilder.parameter, use: getHandler)
		
		buildersRoute.get("search", use: searchHandler)

		buildersRoute.get("first", use: getFirstHandler)

		buildersRoute.get("sorted", use: sortedHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "lines", use: getProductLinesHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "decor-categories", use: getDecorCategoriesHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "decor-items", use: getDecorOptionItemsHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "home-option-categories", use: getHomeOptionCategoriesHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "home-option-items", use: getHomeOptionItemsHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "image-assets", use: getImageAssetsHandler)
		

		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()

		let tokenAuthGroup = buildersRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)

		tokenAuthGroup.post(HomeBuilder.self, use: createHandler)
		
		tokenAuthGroup.delete(HomeBuilder.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HomeBuilder.parameter, use: updateHandler)

	}

	
	func createHandler(_ req: Request, builder: HomeBuilder) throws -> Future<HomeBuilder> {
		
		return builder.save(on: req)
	}

	
	func getAllHandler(_ req: Request) throws -> Future<[HomeBuilder]>
	{
		return HomeBuilder.query(on: req).all()
	}
	

	func getHandler(_ req: Request) throws -> Future<HomeBuilder>
	{
		return try req.parameters.next(HomeBuilder.self)
	}
	
	// Update passed builder with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try flatMap(
			to: HomeBuilder.self,
			req.parameters.next(HomeBuilder.self),
			req.content.decode(HomeBuilder.self)
		) { builder, updatedBuilder in
			builder.name = updatedBuilder.name
			builder.logoURL = updatedBuilder.logoURL
			builder.websiteURL = updatedBuilder.websiteURL
			builder.username = updatedBuilder.username
			
			// Get the authenticated user who is making this change
			//
//			let user = try req.requireAuthenticated(User.self)
			
//			builder.userUpdateID = try user.requireID()

			return builder.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HomeBuilder.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}

	
	func searchHandler(_ req: Request) throws -> Future<[HomeBuilder]>
	{
		guard let searchTerm = req.query[String.self, at: "param"] else {
			throw Abort(.badRequest)
		}
		
		return HomeBuilder.query(on: req).group(.or) { or in
			or.filter(\.name == searchTerm)
			or.filter(\.username == searchTerm)
			}.all()
	}

	
	func getFirstHandler(_ req: Request) throws -> Future<HomeBuilder>
	{
		return HomeBuilder.query(on: req)
			.first()
			
			.map(to: HomeBuilder.self) { homebuilder in
				guard let homebuilder = homebuilder else {
					throw Abort(.notFound)
				}
				
				return homebuilder
		}
	}
	
	
	func sortedHandler(_ req: Request) throws -> Future<[HomeBuilder]>
	{
		return HomeBuilder.query(on: req).sort(\.name, .ascending).all()
	}
	
	
	// Get the builder's product lines
	//
	func getProductLinesHandler(_ req: Request) throws -> Future<[ProductLine]> {
		
		return try req
			.parameters.next(HomeBuilder.self)
			.flatMap(to: [ProductLine].self) { builder in
				
				try builder.productLines.query(on: req).all()
		}
	}
	
	
	// Get the builder's decor categories
	//
	func getDecorCategoriesHandler(_ req: Request) throws -> Future<[DecorOptionCategory]> {
		
		return try req
			.parameters.next(HomeBuilder.self)
			.flatMap(to: [DecorOptionCategory].self) { builder in
				
				try builder.decorCategories.query(on: req).all()
		}
	}
	
	
	// Get the builder's decor options
	//
	func getDecorOptionItemsHandler(_ req: Request) throws -> Future<[DecorOptionItem]> {
		
		return try req
			.parameters.next(HomeBuilder.self)
			.flatMap(to: [DecorOptionItem].self) { builder in
				
				try builder.decorOptions.query(on: req).all()
		}
	}
	
	
	// Get the builder's home option categories
	//
	func getHomeOptionCategoriesHandler(_ req: Request) throws -> Future<[HomeOptionCategory]> {
		
		return try req
			.parameters.next(HomeBuilder.self)
			.flatMap(to: [HomeOptionCategory].self) { builder in
				
				try builder.homeOptionCategories.query(on: req).all()
		}
	}

	
	// Get the builder's home options
	//
	func getHomeOptionItemsHandler(_ req: Request) throws -> Future<[HomeOptionItem]> {
		
		return try req
			.parameters.next(HomeBuilder.self)
			.flatMap(to: [HomeOptionItem].self) { builder in
				
				try builder.homeOptions.query(on: req).all()
		}
	}

	
	// Get the builder's image assets
	//
	func getImageAssetsHandler(_ req: Request) throws -> Future<[ImageAsset]> {
		
		return try req
			.parameters.next(HomeBuilder.self)
			.flatMap(to: [ImageAsset].self) { builder in
				
				try builder.imageAssets.query(on: req).all()
		}
	}

}

