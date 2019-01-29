
import Vapor
import Fluent
import Authentication



struct LineDecorCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let decorCategoriesRoute = router.grouped("api", "line-decor-category")
		
		decorCategoriesRoute.get(use: getAllHandler)
		
		decorCategoriesRoute.get(LineDecorCategory.parameter, use: getHandler)
		
		decorCategoriesRoute.get(LineDecorCategory.parameter, "line", use: getProductLineHandler)
		
		decorCategoriesRoute.get(LineDecorCategory.parameter, "line-decor-items", use: getDecorItemsHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = decorCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(LineDecorCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(LineDecorCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(LineDecorCategory.parameter, use: updateHandler)
		
	}
	
	
	func createHandler(
		_ req: Request,
		category: LineDecorCategory
		) throws -> Future<LineDecorCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[LineDecorCategory]>
	{
		return LineDecorCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<LineDecorCategory>
	{
		return try req.parameters.next(LineDecorCategory.self)
	}
	
	
	// Update passed product category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<LineDecorCategory> {
		
		return try flatMap(
			to: LineDecorCategory.self,
			req.parameters.next(LineDecorCategory.self),
			req.content.decode(LineDecorCategory.self)
		) { category, updatedCategory in
			category.lineID = updatedCategory.lineID
			category.categoryID = updatedCategory.categoryID
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(LineDecorCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the Builder record for this product category
	//
	func getProductLineHandler(_ req: Request) throws -> Future<ProductLine> {
		
		return try req.parameters.next(LineDecorCategory.self).flatMap(to: ProductLine.self) { category in
				
				category.productLine.get(on: req)
		}
	}
	
	
	func getDecorItemsHandler(_ req: Request) throws -> Future<[LineDecorOptionItem]> {
		
		return try req.parameters.next(LineDecorCategory.self).flatMap(to: [LineDecorOptionItem].self) { category in
			
			try category.decorOptions.query(on: req).all()
		}
	}
	
	
}



