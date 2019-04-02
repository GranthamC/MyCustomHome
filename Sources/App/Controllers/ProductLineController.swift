
import Vapor
import Fluent
import Authentication

struct ProductLineResponse: Content
{
	var name: String
	var logoURL: String?
	var websiteURL: String?
	
	var homeModels: [HomeModel]
	
	init(line: ProductLine, models: [HomeModel])
	{
		
		self.name = line.name
		self.logoURL = line.logoURL
		self.websiteURL = line.websiteURL
		
		self.homeModels = models
	}
}


struct ProductLineController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let productLinesRoute = router.grouped("api", "line")
		
		productLinesRoute.get(use: getAllHandler)
		
		productLinesRoute.get(ProductLine.parameter, use: getHandler)

		productLinesRoute.get(ProductLine.parameter, "builder", use: getBuilderHandler)
		
		productLinesRoute.get(ProductLine.parameter, "home-models", use: getHomeModelsHandler)
		
		productLinesRoute.get(ProductLine.parameter, "decor-categories", use: getCategoriesHandler)

		productLinesRoute.get(ProductLine.parameter, "decor-packages", use: getDecorPackagesHandler)

		productLinesRoute.get("lines-info", use: all)

		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = productLinesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		tokenAuthGroup.post(ProductLine.self, use: createHandler)
		
		tokenAuthGroup.delete(ProductLine.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(ProductLine.parameter, use: updateHandler)
		
		tokenAuthGroup.post(ProductLine.parameter, "home-model", HomeModel.parameter, use: addHomeModelHandler)
		
		tokenAuthGroup.delete(ProductLine.parameter, "home-model", HomeModel.parameter, use: removeHomeModelHandler)

		tokenAuthGroup.post(ProductLine.parameter, "decor-package", DecorPackage.parameter, use: addDecorPackageHandler)
		
		tokenAuthGroup.delete(ProductLine.parameter, "decor-package", DecorPackage.parameter, use: removeDecorPackageHandler)
	}
	
	func all(_ request: Request) throws -> Future<[ProductLineResponse]> {
		
		return ProductLine.query(on: request).all().flatMap { lines in
			
			let lineResponseFutures = try lines.map { line in
				
				try line.homeModels.query(on: request).all().map { models in
					return ProductLineResponse(line: line, models: models)
				}
			}
			
			return lineResponseFutures.flatten(on: request)
		}
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
			line.changeToken = updatedLine.changeToken

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

	
	// Get the line's decor categories
	//
	func getCategoriesHandler(_ req: Request) throws -> Future<[LineDecorCategory]> {
		
		return try req
			.parameters.next(ProductLine.self)
			.flatMap(to: [LineDecorCategory].self) { line in
				
				try line.decorCategories.query(on: req).all()
		}
	}
	
	
	func addDecorPackageHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(ProductLine.self), req.parameters.next(DecorPackage.self))
		{ line, item in
			
			return line.decorPackages.attach(item, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getDecorPackagesHandler(_ req: Request) throws -> Future<[DecorPackage]> {
		
		return try req.parameters.next(ProductLine.self).flatMap(to: [DecorPackage].self) { line in
			
			try line.decorPackages.query(on: req).all()
		}
	}
	
	func removeDecorPackageHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(ProductLine.self), req.parameters.next(DecorPackage.self)) { line, item in
			
			return line.decorPackages.detach(item, on: req).transform(to: .noContent)
		}
	}

}

