
import Vapor



struct ProductLineController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let productLinesRoute = router.grouped("api", "lines")
		
		productLinesRoute.post(ProductLine.self, use: createHandler)
		
		productLinesRoute.get(use: getAllHandler)
		
		productLinesRoute.get(ProductLine.parameter, use: getHandler)

		productLinesRoute.put(ProductLine.parameter, use: updateHandler)
		
		productLinesRoute.get(ProductLine.parameter, "builder", use: getBuilderHandler)
		
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
			line.id = updatedLine.id
			line.name = updatedLine.name
			line.logoURL = updatedLine.logoURL
			line.builderID = updatedLine.builderID
			return line.save(on: req)
		}
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
	
	
}

