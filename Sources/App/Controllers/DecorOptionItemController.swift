
import Vapor
import Fluent
import Authentication


struct DecorOptionItemController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let decorItemsRoute = router.grouped("api", "decor-item")
		
//		decorItemsRoute.post(DecorOptionItem.self, use: createHandler)
		
		decorItemsRoute.get(use: getAllHandler)
		
		decorItemsRoute.get(DecorOptionItem.parameter, use: getHandler)
		
//		decorItemsRoute.put(DecorOptionItem.parameter, use: updateHandler)

//		decorItemsRoute.delete(HomeBuilder.parameter, use: deleteHandler)
		
		decorItemsRoute.get("search", use: searchHandler)
		
		decorItemsRoute.get("first", use: getFirstHandler)
		
		decorItemsRoute.get("sorted", use: sortedHandler)

		decorItemsRoute.get(DecorOptionItem.parameter, "builder", use: getBuilderHandler)		

		decorItemsRoute.get(DecorOptionItem.parameter, "decor-category", use: getCategoryHandler)

		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = decorItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(DecorOptionItem.self, use: createHandler)
		
		tokenAuthGroup.delete(DecorOptionItem.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(DecorOptionItem.parameter, use: updateHandler)
	}
	
	
	func createHandler(
		_ req: Request,
		decorItem: DecorOptionItem
		) throws -> Future<DecorOptionItem> {
		
		return decorItem.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[DecorOptionItem]>
	{
		return DecorOptionItem.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<DecorOptionItem>
	{
		return try req.parameters.next(DecorOptionItem.self)
	}
	
	
	// Update passed product decor Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<DecorOptionItem> {
		
		return try flatMap(
			to: DecorOptionItem.self,
			req.parameters.next(DecorOptionItem.self),
			req.content.decode(DecorOptionItem.self)
		) { decorItem, updatedItem in
			decorItem.name = updatedItem.name
			decorItem.builderID = updatedItem.builderID
			decorItem.optionType = updatedItem.optionType

			decorItem.optionImageURL = updatedItem.name
			decorItem.optionModelURL = updatedItem.optionModelURL
			decorItem.decorOptionColor = updatedItem.decorOptionColor
			decorItem.imageScale = updatedItem.imageScale
			decorItem.imageScale = updatedItem.imageScale
			decorItem.physicalWidth = updatedItem.physicalWidth
			decorItem.physicalHeight = updatedItem.physicalHeight

			return decorItem.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(DecorOptionItem.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	func searchHandler(_ req: Request) throws -> Future<[DecorOptionItem]>
	{
		guard let searchTerm = req.query[String.self, at: "param"] else {
			throw Abort(.badRequest)
		}
		
		return DecorOptionItem.query(on: req).group(.or) { or in
			or.filter(\.name == searchTerm)
			}.all()
	}
	
	
	func getFirstHandler(_ req: Request) throws -> Future<DecorOptionItem>
	{
		return DecorOptionItem.query(on: req)
			.first()
			
			.map(to: DecorOptionItem.self) { optionItem in
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

	// Get the Builder record for this decor Item
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req
			.parameters.next(DecorOptionItem.self)
			.flatMap(to: HomeBuilder.self) { decorItem in
				
				decorItem.builder.get(on: req)
		}
	}

	// Get the category record for this decor Item
	//
	func getCategoryHandler(_ req: Request) throws -> Future<DecorOptionCategory> {
		
		return try req.parameters.next(DecorOptionItem.self).flatMap(to: DecorOptionCategory.self) { decorItem in
			
			decorItem.category.get(on: req)
		}
	}

}



