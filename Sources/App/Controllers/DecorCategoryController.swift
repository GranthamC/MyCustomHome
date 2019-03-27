import Vapor
import Fluent
import Authentication


struct DecorOptionCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "decor-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(DecorCategory.parameter, use: getHandler)
		
		homeOptionsCategoriesRoute.get(DecorCategory.parameter, "builder", use: getBuilderHandler)
		
		homeOptionsCategoriesRoute.get(DecorCategory.parameter, "decor-items", use: getCategoryOptionsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(DecorCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(DecorCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(DecorCategory.parameter, use: updateHandler)
		
	}
	
	
	func createHandler(
		_ req: Request,
		category: DecorCategory
		) throws -> Future<DecorCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[DecorCategory]>
	{
		return DecorCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<DecorCategory>
	{
		return try req.parameters.next(DecorCategory.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<DecorCategory> {
		
		return try flatMap(
			to: DecorCategory.self,
			req.parameters.next(DecorCategory.self),
			req.content.decode(DecorCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.builderID = updatedCategory.builderID
			category.optionType = updatedCategory.optionType
			category.changeToken = updatedCategory.changeToken
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(DecorCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the Builder record for this category
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(DecorCategory.self).flatMap(to: HomeBuilder.self) { category in
			
			category.builder.get(on: req)
		}
	}
	
	
	// Get the category options for this category
	//
	func getCategoryOptionsHandler(_ req: Request) throws -> Future<[DecorItem]> {
		
		return try req
			.parameters.next(DecorCategory.self)
			.flatMap(to: [DecorItem].self) { category in
				
				try category.categoryOptions.query(on: req).all()
		}
	}

	
/*
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(DecorCategory.self), req.parameters.next(DecorItem.self))
		{ category, optionItem in
			
			return category.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[DecorItem]> {
		
		return try req.parameters.next(DecorCategory.self).flatMap(to: [DecorItem].self) { category in
			
			try category.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(DecorCategory.self), req.parameters.next(DecorItem.self)) { category, optionItem in
			
			return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}
*/
}




