import Vapor
import Fluent
import Authentication


struct DecorOptionCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "decor-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(DecorOptionCategory.parameter, use: getHandler)
		
		homeOptionsCategoriesRoute.get(DecorOptionCategory.parameter, "builder", use: getBuilderHandler)
		
		homeOptionsCategoriesRoute.get(DecorOptionCategory.parameter, "decor-items", use: getOptionItemHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(DecorOptionCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(DecorOptionCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(DecorOptionCategory.parameter, use: updateHandler)
		
		tokenAuthGroup.post(DecorOptionCategory.parameter, "decor-item", DecorOptionItem.parameter, use: addOptionItemHandler)
		
		tokenAuthGroup.delete(DecorOptionCategory.parameter, "decor-item", DecorOptionItem.parameter, use: removeOptionItemHandler)
		
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
	
	
	// Update passed category with parameters
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
			category.changeToken = updatedCategory.changeToken
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(DecorOptionCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the Builder record for this category
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(DecorOptionCategory.self).flatMap(to: HomeBuilder.self) { category in
			
			category.builder.get(on: req)
		}
	}
	
	
	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(DecorOptionCategory.self), req.parameters.next(DecorOptionItem.self))
		{ category, optionItem in
			
			return category.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[DecorOptionItem]> {
		
		return try req.parameters.next(DecorOptionCategory.self).flatMap(to: [DecorOptionItem].self) { category in
			
			try category.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(DecorOptionCategory.self), req.parameters.next(DecorOptionItem.self)) { category, optionItem in
			
			return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}
	
}




