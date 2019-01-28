
import Vapor
import Fluent
import Authentication



struct DecorCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let decorCategoriesRoute = router.grouped("api", "decor-category")
		
//		decorCategoriesRoute.post(DecorOptionCategory.self, use: createHandler)
		
		decorCategoriesRoute.get(use: getAllHandler)
		
		decorCategoriesRoute.get(DecorOptionCategory.parameter, use: getHandler)
		
//		decorCategoriesRoute.put(DecorOptionCategory.parameter, use: updateHandler)

//		decorCategoriesRoute.delete(DecorOptionCategory.parameter, use: deleteHandler)

		decorCategoriesRoute.get(DecorOptionCategory.parameter, "builder", use: getBuilderHandler)
	
		decorCategoriesRoute.get(DecorOptionCategory.parameter, "decor-items", use: getDecorItemsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = decorCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(DecorOptionCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(DecorOptionCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(DecorOptionCategory.parameter, use: updateHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		category: DecorOptionCategory
		) throws -> Future<DecorOptionCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[DecorOptionCategory]>
	{
		return DecorOptionCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<DecorOptionCategory>
	{
		return try req.parameters.next(DecorOptionCategory.self)
	}
	
	
	// Update passed product category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<DecorOptionCategory> {
		
		return try flatMap(
			to: DecorOptionCategory.self,
			req.parameters.next(DecorOptionCategory.self),
			req.content.decode(DecorOptionCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.builderID = updatedCategory.builderID
			category.optionType = updatedCategory.optionType
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(DecorOptionCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}

	
	// Get the Builder record for this product category
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req
			.parameters.next(DecorOptionCategory.self)
			.flatMap(to: HomeBuilder.self) { category in
				
				category.builder.get(on: req)
		}
	}
	

	func getDecorItemsHandler(_ req: Request) throws -> Future<[DecorOptionItem]> {

		return try req.parameters.next(DecorOptionCategory.self)
			.flatMap(to: [DecorOptionItem].self) { category in

				try category.decorOptions.query(on: req).all()
		}
	}
	
	
}


