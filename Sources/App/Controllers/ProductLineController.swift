
import Vapor



struct ProductLineController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let productLinesRoute = router.grouped("api", "line")
		
		productLinesRoute.post(ProductLine.self, use: createHandler)
		
		productLinesRoute.get(use: getAllHandler)
		
		productLinesRoute.get(ProductLine.parameter, use: getHandler)

		productLinesRoute.put(ProductLine.parameter, use: updateHandler)

		productLinesRoute.delete(ProductLine.parameter, use: deleteHandler)

		productLinesRoute.get(ProductLine.parameter, "builder", use: getBuilderHandler)
		
		productLinesRoute.get(ProductLine.parameter, "homes", use: getHomeModelsHandler)
		
		productLinesRoute.get(ProductLine.parameter, "decor-items", use: getDecorItemsHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		line: ProductLine
		) throws -> Future<ProductLine> {
		
		return line.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[ProductLine]>
	{
		return ProductLine.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<ProductLine>
	{
		return try req.parameters.next(ProductLine.self)
	}
	
	
	// Update passed product line with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<ProductLine> {
		
		return try flatMap(
			to: ProductLine.self,
			req.parameters.next(ProductLine.self),
			req.content.decode(ProductLine.self)
		) { line, updatedLine in
			
			line.name = updatedLine.name
			line.builderID = updatedLine.builderID
			line.logoURL = updatedLine.logoURL
			line.websiteURL = updatedLine.websiteURL

			return line.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(ProductLine.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	

	// Get the Builder record for this product line
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req
			.parameters.next(ProductLine.self)
			.flatMap(to: HomeBuilder.self) { line in
				
				line.builder.get(on: req)
		}
	}
	
	
	// Get the line's home models
	//
	func getHomeModelsHandler(_ req: Request) throws -> Future<[HomeModel]> {
		
		return try req
			.parameters.next(ProductLine.self)
			.flatMap(to: [HomeModel].self) { line in
				
				try line.homeModels.query(on: req).all()
		}
	}
	
	
	func getDecorItemsHandler(_ req: Request) throws -> Future<[DecorOptionItem]> {
		
		return try req.parameters.next(ProductLine.self)
			.flatMap(to: [DecorOptionItem].self) { line in
				
				try line.decorOptions.query(on: req).all()
		}
	}
	
}

