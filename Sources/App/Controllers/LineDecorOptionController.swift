
import Vapor
import Fluent
import Authentication


struct LineDecorOptionController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let decorItemsRoute = router.grouped("api", "line-decor-item")
		
		decorItemsRoute.get(use: getAllHandler)
		
		decorItemsRoute.get(LineDecorOptionItem.parameter, use: getHandler)
		
		decorItemsRoute.get("search", use: searchHandler)
		
		decorItemsRoute.get("first", use: getFirstHandler)
		
		decorItemsRoute.get("sorted", use: sortedHandler)
		
		decorItemsRoute.get(LineDecorOptionItem.parameter, "line-decor-category", use: getCategoryHandler)
		
		decorItemsRoute.get(LineDecorOptionItem.parameter, "decor-item", use: getOptionItemHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = decorItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(LineDecorOptionItem.self, use: createHandler)
		
		tokenAuthGroup.delete(LineDecorOptionItem.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(LineDecorOptionItem.parameter, use: updateHandler)
	}
	
	
	func createHandler(
		_ req: Request,
		decorItem: LineDecorOptionItem
		) throws -> Future<LineDecorOptionItem> {
		
		return decorItem.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[LineDecorOptionItem]>
	{
		return LineDecorOptionItem.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<LineDecorOptionItem>
	{
		return try req.parameters.next(LineDecorOptionItem.self)
	}
	
	
	// Update passed product decor Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<LineDecorOptionItem> {
		
		return try flatMap(
			to: LineDecorOptionItem.self,
			req.parameters.next(LineDecorOptionItem.self),
			req.content.decode(LineDecorOptionItem.self)
		) { decorItem, updatedItem in
			decorItem.name = updatedItem.name
			decorItem.itemID = updatedItem.itemID
			decorItem.categoryID = updatedItem.categoryID
			
			return decorItem.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(LineDecorOptionItem.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	func searchHandler(_ req: Request) throws -> Future<[LineDecorOptionItem]>
	{
		guard let searchTerm = req.query[String.self, at: "param"] else {
			throw Abort(.badRequest)
		}
		
		return LineDecorOptionItem.query(on: req).group(.or) { or in
			or.filter(\.name == searchTerm)
			}.all()
	}
	
	
	func getFirstHandler(_ req: Request) throws -> Future<LineDecorOptionItem>
	{
		return LineDecorOptionItem.query(on: req)
			.first()
			
			.map(to: LineDecorOptionItem.self) { optionItem in
				guard let item = optionItem else {
					throw Abort(.notFound)
				}
				
				return item
		}
	}
	
	
	func sortedHandler(_ req: Request) throws -> Future<[HomeBuilder]>
	{
		return HomeBuilder.query(on: req).sort(\.name, .ascending).all()
	}
	
	// Get the Category record for this decor Item
	//
	func getCategoryHandler(_ req: Request) throws -> Future<LineDecorCategory> {
		
		return try req
			.parameters.next(LineDecorOptionItem.self)
			.flatMap(to: LineDecorCategory.self) { decorItem in
				
				decorItem.lineCategory.get(on: req)
		}
	}
	
	// Get the category record for this decor Item
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<DecorOptionItem> {
		
		return try req.parameters.next(LineDecorOptionItem.self).flatMap(to: DecorOptionItem.self) { decorItem in
			
			decorItem.decorOption.get(on: req)
		}
	}
	
}




