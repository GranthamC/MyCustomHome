import Vapor
import Fluent


struct BuilderController: RouteCollection
{

	
	func boot(router: Router) throws
	{
		let builderRoutes = router.grouped("api", "builder")
		
		builderRoutes.get(use: getAllHandler)
		
		builderRoutes.post(use: createHandler)

		builderRoutes.get(Builder.parameter, use: getHandler)

		builderRoutes.put(Builder.parameter, use: updateHandler)

		builderRoutes.delete(Builder.parameter, use: deleteHandler)

		builderRoutes.get("search", use: searchHandler)

		builderRoutes.get("first", use: getFirstHandler)

		builderRoutes.get("sorted", use: sortedHandler)
	}
	
	// Get all
	//
	func getAllHandler(_ req: Request) throws -> Future<[Builder]>
	{
		return Builder.query(on: req).all()
	}
	
	// Create new builder
	//
	func createHandler(_ req: Request) throws -> Future<Builder> {

		return try req
			.content
			.decode(Builder.self)
			.flatMap(to: Builder.self) { builder in
				return builder.save(on: req)
		}
	}
	
	// Get with passed parameters
	//
	func getHandler(_ req: Request) throws -> Future<Builder> {
		return try req.parameters.next(Builder.self)
	}
	
	// Update passed builder with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<Builder> {
		
		return try flatMap(
			to: Builder.self,
			req.parameters.next(Builder.self),
			req.content.decode(Builder.self)
		) { builder, updatedBuilder in
			builder.short = updatedBuilder.short
			builder.long = updatedBuilder.long
			return builder.save(on: req)
		}
	}
	
	
	// Delete the passed builder
	//
	func deleteHandler(_ req: Request)
		throws -> Future<HTTPStatus> {
			
			return try req
				.parameters
				.next(Builder.self)
				.delete(on: req)
				.transform(to: HTTPStatus.noContent)
	}
	
	
	// Search builders for...
	//
	func searchHandler(_ req: Request) throws -> Future<[Builder]> {
		guard let searchTerm = req
			.query[String.self, at: "term"] else {
				throw Abort(.badRequest)
		}
		return Builder.query(on: req).group(.or) { or in
			or.filter(\.short == searchTerm)
			or.filter(\.long == searchTerm)
			}.all()
	}
	
	
	// Get first builder result
	//
	func getFirstHandler(_ req: Request) throws -> Future<Builder> {
		return Builder.query(on: req)
			.first()
			.map(to: Builder.self) { builder in
				guard let builder = builder else {
					throw Abort(.notFound)
				}
				return builder
		}
	}
	
	
	// return all builders sorted by name
	//
	func sortedHandler(_ req: Request) throws -> Future<[Builder]> {
		return Builder.query(on: req) .sort(\.short, .ascending) .all()
	}


}
