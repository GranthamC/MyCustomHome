
import Vapor
import Fluent
import Authentication



struct ProductLineController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let productLinesRoute = router.grouped("api", "line")
		
		productLinesRoute.get(use: getAllHandler)
		
		productLinesRoute.get(ProductLine.parameter, use: getHandler)

		productLinesRoute.get(ProductLine.parameter, "builder", use: getBuilderHandler)
		
		productLinesRoute.get(ProductLine.parameter, "homes", use: getHomeModelsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = productLinesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		tokenAuthGroup.post(ProductLine.self, use: createHandler)
		
		tokenAuthGroup.delete(ProductLine.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(ProductLine.parameter, use: updateHandler)
		
		tokenAuthGroup.post(ProductLine.parameter, "homes", HomeModel.parameter, use: addHomeModelHandler)
		
		tokenAuthGroup.delete(ProductLine.parameter, "homes", HomeModel.parameter, use: removeHomeModelHandler)
	}
	
	func createHandler(_ req: Request, line: ProductLine) throws -> Future<ProductLine> {
		
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
	
	
	func addHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(ProductLine.self), req.parameters.next(HomeModel.self))
		{ line, model in
			
			return line.homeModels.attach(model, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getHomeModelsHandler(_ req: Request) throws -> Future<[HomeModel]> {
		
		return try req.parameters.next(ProductLine.self).flatMap(to: [HomeModel].self) { line in
			
			try line.homeModels.query(on: req).all()
		}
	}
	
	func removeHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus> {

		return try flatMap(to: HTTPStatus.self, req.parameters.next(ProductLine.self), req.parameters.next(HomeModel.self)) { line, model in

			return line.homeModels.detach(model, on: req).transform(to: .noContent)
		}
	}
	
}

