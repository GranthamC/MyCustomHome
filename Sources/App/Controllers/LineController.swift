
import Vapor
import Fluent
import Authentication

struct ProductLineResponse: Content
{
	var name: String
	var logoURL: String?
	var websiteURL: String?
	
	var homeModels: [HomeModel]
	
	init(line: Line, models: [HomeModel])
	{
		
		self.name = line.name
		self.logoURL = line.logoURL
		self.websiteURL = line.websiteURL
		
		self.homeModels = models
	}
}


struct LineController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let productLinesRoute = router.grouped("api", "line")
		
		productLinesRoute.get(use: getAllHandler)
		
		productLinesRoute.get(Line.parameter, use: getHandler)
		
		productLinesRoute.get("search", use: searchHandler)

		productLinesRoute.get(Line.parameter, "builder", use: getBuilderHandler)
		
		productLinesRoute.get(Line.parameter, "home-models", use: getHomeModelsHandler)
		
		productLinesRoute.get(Line.parameter, "homes", use: getHomesHandler)

		productLinesRoute.get(Line.parameter, "decor-categories", use: getCategoriesHandler)

		productLinesRoute.get(Line.parameter, "decor-packages", use: getDecorPackagesHandler)

		productLinesRoute.get("lines-info", use: all)

		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = productLinesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		tokenAuthGroup.post(Line.self, use: createHandler)
		
		tokenAuthGroup.delete(Line.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(Line.parameter, use: updateHandler)
		
		tokenAuthGroup.post(Line.parameter, "home-model", HomeModel.parameter, use: addHomeModelHandler)
		
		tokenAuthGroup.delete(Line.parameter, "home-model", HomeModel.parameter, use: removeHomeModelHandler)

		tokenAuthGroup.post(Line.parameter, "decor-package", DecorPackage.parameter, use: addDecorPackageHandler)
		
		tokenAuthGroup.delete(Line.parameter, "decor-package", DecorPackage.parameter, use: removeDecorPackageHandler)
	}
	
	func all(_ request: Request) throws -> Future<[ProductLineResponse]> {
		
		return Line.query(on: request).all().flatMap { lines in
			
			let lineResponseFutures = try lines.map { line in
				
				try line.homeModels.query(on: request).all().map { models in
					return ProductLineResponse(line: line, models: models)
				}
			}
			
			return lineResponseFutures.flatten(on: request)
		}
	}
	
	func createHandler(_ req: Request, line: Line) throws -> Future<Line> {
		
		return line.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[Line]>
	{
		return Line.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<Line>
	{
		return try req.parameters.next(Line.self)
	}

	
	func searchHandler(_ req: Request) throws -> Future<[Line]>
	{
		guard let searchTerm = req.query[String.self, at: "param"] else {
			throw Abort(.badRequest)
		}
		
		return Line.query(on: req).group(.or) { or in
			or.filter(\.lineID == searchTerm)
			or.filter(\.lineDescription == searchTerm)
			or.filter(\.plantNumber == searchTerm)
			}.all()
	}

	
	// Update passed product line with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<Line> {
		
		return try flatMap(
			to: Line.self,
			req.parameters.next(Line.self),
			req.content.decode(Line.self)
		) { line, updatedLine in
			
			line.name = updatedLine.name
			line.plantModelID = updatedLine.plantModelID
			line.logoURL = updatedLine.logoURL
			line.websiteURL = updatedLine.websiteURL
			line.changeToken = updatedLine.changeToken
			
			line.lineID = updatedLine.lineID
			line.lineDescription = updatedLine.lineDescription
			line.acronym = updatedLine.acronym
			line.plantID = updatedLine.plantID
			line.plantNumber = updatedLine.plantNumber

			return line.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(Line.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	

	// Get the Builder record for this product line
	//
	func getBuilderHandler(_ req: Request) throws -> Future<Plant> {
		
		return try req
			.parameters.next(Line.self)
			.flatMap(to: Plant.self) { line in
				
				line.builder.get(on: req)
		}
	}
	
	
	func addHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(Line.self), req.parameters.next(HomeModel.self))
		{ line, model in
			
			return line.homeModels.attach(model, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getHomeModelsHandler(_ req: Request) throws -> Future<[HomeModel]> {
		
		return try req.parameters.next(Line.self).flatMap(to: [HomeModel].self) { line in
			
			try line.homeModels.query(on: req).all()
		}
	}
	
	func removeHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus> {

		return try flatMap(to: HTTPStatus.self, req.parameters.next(Line.self), req.parameters.next(HomeModel.self)) { line, model in

			return line.homeModels.detach(model, on: req).transform(to: .noContent)
		}
	}
	
	
	//  Get the homes belonging to this line
	//
	func getHomesHandler(_ req: Request) throws -> Future<[HomeModel]> {
		
		return try req
			.parameters.next(Line.self)
			.flatMap(to: [HomeModel].self) { line in
				
				try line.homes.query(on: req).all()
		}
	}

	
	// Get the line's decor categories
	//
	func getCategoriesHandler(_ req: Request) throws -> Future<[LineDecorCategory]> {
		
		return try req
			.parameters.next(Line.self)
			.flatMap(to: [LineDecorCategory].self) { line in
				
				try line.decorCategories.query(on: req).all()
		}
	}
	
	
	func addDecorPackageHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(Line.self), req.parameters.next(DecorPackage.self))
		{ line, item in
			
			return line.decorPackages.attach(item, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getDecorPackagesHandler(_ req: Request) throws -> Future<[DecorPackage]> {
		
		return try req.parameters.next(Line.self).flatMap(to: [DecorPackage].self) { line in
			
			try line.decorPackages.query(on: req).all()
		}
	}
	
	func removeDecorPackageHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(Line.self), req.parameters.next(DecorPackage.self)) { line, item in
			
			return line.decorPackages.detach(item, on: req).transform(to: .noContent)
		}
	}

}

