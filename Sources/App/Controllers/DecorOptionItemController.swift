
import Vapor



struct DecorOptionItemController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let decorItemsRoute = router.grouped("api", "decor-item")
		
		decorItemsRoute.post(DecorOptionItem.self, use: createHandler)
		
		decorItemsRoute.get(use: getAllHandler)
		
		decorItemsRoute.get(DecorOptionItem.parameter, use: getHandler)
		
		decorItemsRoute.put(DecorOptionItem.parameter, use: updateHandler)
		
		decorItemsRoute.get(DecorOptionItem.parameter, "builder", use: getBuilderHandler)
		
		decorItemsRoute.post(DecorOptionItem.parameter, "lines", ProductLine.parameter, use: addLinesHandler)
		
		decorItemsRoute.get(DecorOptionItem.parameter, "lines", use: getLinesHandler)
		
		decorItemsRoute.delete(DecorOptionItem.parameter, "lines", ProductLine.parameter, 	use: removeLinesHandler)

		decorItemsRoute.post(DecorOptionItem.parameter, "categories", DecorOptionCategory.parameter, use: addCategoriesHandler)
		
		decorItemsRoute.get(DecorOptionItem.parameter, "categories", use: getCategoriesHandler)
		
		decorItemsRoute.delete(DecorOptionItem.parameter, "categories", DecorOptionCategory.parameter, 	use: removeCategoriesHandler)

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
		) { decorItem, updatedLine in
			decorItem.id = updatedLine.id
			decorItem.name = updatedLine.name
			decorItem.logoURL = updatedLine.logoURL
			decorItem.builderID = updatedLine.builderID
			return decorItem.save(on: req)
		}
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
	
	
	func addLinesHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(DecorOptionItem.self),
			req.parameters.next(ProductLine.self)) { decorOption, line in
				
				return decorOption.lines .attach(line, on: req) .transform(to: .created)
		}
	}
	
	
	func getLinesHandler(_ req: Request ) throws -> Future<[ProductLine]> {
		
		return try req.parameters.next(DecorOptionItem.self)
			.flatMap(to: [ProductLine].self) { decorOption in
				
				try decorOption.lines.query(on: req).all()
		}
	}
	
	
	func removeLinesHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(DecorOptionItem.self),
			req.parameters.next(ProductLine.self)
		) { optionItem, line in
			
			return optionItem.lines .detach(line, on: req) .transform(to: .noContent)
		}
	}

	
	func addCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(DecorOptionItem.self),
			req.parameters.next(DecorOptionCategory.self)) { decorOption, category in
				
				return decorOption.categories .attach(category, on: req) .transform(to: .created)
		}
	}
	
	
	func getCategoriesHandler(_ req: Request ) throws -> Future<[DecorOptionCategory]> {

		return try req.parameters.next(DecorOptionItem.self)
			.flatMap(to: [DecorOptionCategory].self) { decorOption in

				try decorOption.categories.query(on: req).all()
		}
	}
	
	
	func removeCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {

		return try flatMap(
			to: HTTPStatus.self,
			req.parameters.next(DecorOptionItem.self),
			req.parameters.next(DecorOptionCategory.self)
		) { optionItem, category in

			return optionItem.categories .detach(category, on: req) .transform(to: .noContent)
		}
	}

}



