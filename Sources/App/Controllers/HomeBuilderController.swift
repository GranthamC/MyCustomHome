import Vapor



struct HomeBuilderController: RouteCollection
{

	func boot(router: Router) throws {

		let buildersRoute = router.grouped("api", "builder")
 
		buildersRoute.post(HomeBuilder.self, use: createHandler)
		
		buildersRoute.get(use: getAllHandler)

		buildersRoute.get(HomeBuilder.parameter, use: getHandler)

		buildersRoute.put(HomeBuilder.parameter, use: updateHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "lines", use: getProductLinesHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "decor-categories", use: getDecorCategoriesHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "decor-items", use: getDecorOptionItemsHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "home-option-categories", use: getHomeOptionCategoriesHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "home-option-items", use: getHomeOptionItemsHandler)
	}

	
	func createHandler(
		_ req: Request,
		builder: HomeBuilder
		) throws -> Future<HomeBuilder> {

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
			builder.id = updatedBuilder.id
			builder.name = updatedBuilder.name
			builder.logoURL = updatedBuilder.logoURL
			builder.websiteURL = updatedBuilder.websiteURL
			return builder.save(on: req)
		}
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

}

