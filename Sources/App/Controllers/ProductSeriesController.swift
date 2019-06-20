
import Vapor
import Fluent
import Authentication


struct ProductSeriesController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let productSeriesRoute = router.grouped("api", "series")
		
		productSeriesRoute.get(use: getAllHandler)
		
		productSeriesRoute.get(ProductSeries.parameter, use: getHandler)
		
		productSeriesRoute.get(ProductSeries.parameter, "builder", use: getBuilderHandler)
		
		productSeriesRoute.get(ProductSeries.parameter, "line", use: getProductLineHandler)

		productSeriesRoute.get(ProductSeries.parameter, "home-models", use: getHomeModelsHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = productSeriesRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		tokenAuthGroup.post(ProductSeries.self, use: createHandler)
		
		tokenAuthGroup.delete(ProductSeries.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(ProductSeries.parameter, use: updateHandler)
		
		tokenAuthGroup.post(ProductSeries.parameter, "home-model", HomeModel.parameter, use: addHomeModelHandler)
		
		tokenAuthGroup.delete(ProductSeries.parameter, "home-model", HomeModel.parameter, use: removeHomeModelHandler)
	}

	
	func createHandler(_ req: Request, series: ProductSeries) throws -> Future<ProductSeries> {
		
		return series.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[ProductSeries]>
	{
		return ProductSeries.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<ProductSeries>
	{
		return try req.parameters.next(ProductSeries.self)
	}
	
	
	// Update passed product series with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<ProductSeries> {
		
		return try flatMap(
			to: ProductSeries.self,
			req.parameters.next(ProductSeries.self),
			req.content.decode(ProductSeries.self)
		) { series, updatedLine in
			
			series.name = updatedLine.name
			series.plantID = updatedLine.plantID
			series.lineID = updatedLine.lineID
			series.logoURL = updatedLine.logoURL
			series.websiteURL = updatedLine.websiteURL
			series.changeToken = updatedLine.changeToken
			
			series.heroImageURL = updatedLine.heroImageURL
			series.features = updatedLine.features
			series.priceBase = updatedLine.priceBase
			series.priceUpper = updatedLine.priceUpper
			
			return series.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(ProductSeries.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the Builder record for this product series
	//
	func getBuilderHandler(_ req: Request) throws -> Future<Plant> {
		
		return try req
			.parameters.next(ProductSeries.self)
			.flatMap(to: Plant.self) { series in
				
				series.builder.get(on: req)
		}
	}
	
	
	// Get the product series record for this product series
	//
	func getProductLineHandler(_ req: Request) throws -> Future<Line> {
		
		return try req
			.parameters.next(ProductSeries.self)
			.flatMap(to: Line.self) { series in
				
				series.line.get(on: req)
		}
	}

	
	func addHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(ProductSeries.self), req.parameters.next(HomeModel.self))
		{ series, model in
			
			return series.homeModels.attach(model, on: req).transform(to: .created)
		}
	}
	
	// Get the series's home models
	//
	func getHomeModelsHandler(_ req: Request) throws -> Future<[HomeModel]> {
		
		return try req.parameters.next(ProductSeries.self).flatMap(to: [HomeModel].self) { series in
			
			try series.homeModels.query(on: req).all()
		}
	}
	
	func removeHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(ProductSeries.self), req.parameters.next(HomeModel.self)) { series, model in
			
			return series.homeModels.detach(model, on: req).transform(to: .noContent)
		}
	}
	
}


