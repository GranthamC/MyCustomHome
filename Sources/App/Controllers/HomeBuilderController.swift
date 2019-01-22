import Vapor



struct HomeBuilderController: RouteCollection
{

	func boot(router: Router) throws {

		let buildersRoute = router.grouped("api", "builders")
 
		buildersRoute.post(HomeBuilder.self, use: createHandler)
		
		buildersRoute.get(use: getAllHandler)

		buildersRoute.get(HomeBuilder.parameter, use: getHandler)

		buildersRoute.put(HomeBuilder.parameter, use: updateHandler)
		
		buildersRoute.get(HomeBuilder.parameter, "lines", use: getProductLinesHandler)
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
	
}

