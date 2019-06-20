import Vapor
import Fluent
import Authentication


struct LineDecorCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "line-decor-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(LineDecorCategory.parameter, use: getHandler)
		
		homeOptionsCategoriesRoute.get(LineDecorCategory.parameter, "line", use: getProductLineHandler)
		
		homeOptionsCategoriesRoute.get(LineDecorCategory.parameter, "decor-category", use: getDecorCategoryHandler)

		homeOptionsCategoriesRoute.get(LineDecorCategory.parameter, "decor-items", use: getCategoryItemsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(LineDecorCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(LineDecorCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(LineDecorCategory.parameter, use: updateHandler)
		
		tokenAuthGroup.post(LineDecorCategory.parameter, "decor-item", DecorItem.parameter, use: addOptionItemHandler)
		
		tokenAuthGroup.delete(LineDecorCategory.parameter, "decor-item", DecorItem.parameter, use: removeOptionItemHandler)
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
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<LineDecorCategory> {
		
		return try flatMap(
			to: LineDecorCategory.self,
			req.parameters.next(LineDecorCategory.self),
			req.content.decode(LineDecorCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.lineID = updatedCategory.lineID
			category.optionType = updatedCategory.optionType
			category.changeToken = updatedCategory.changeToken
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(LineDecorCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the product line record for this category
	//
	func getProductLineHandler(_ req: Request) throws -> Future<Line> {
		
		return try req.parameters.next(LineDecorCategory.self).flatMap(to: Line.self) { category in
			
			category.productLine.get(on: req)
		}
	}
	
	
	// Get the product line record for this category
	//
	func getDecorCategoryHandler(_ req: Request) throws -> Future<DecorCategory> {
		
		return try req.parameters.next(LineDecorCategory.self).flatMap(to: DecorCategory.self) { category in
			
			category.decorCategory.get(on: req)
		}
	}

	
	// Get the category options for this category
	//
	func getCategoryItemsHandler(_ req: Request) throws -> Future<[DecorItem]> {
		
		return try req
			.parameters.next(LineDecorCategory.self)
			.flatMap(to: [DecorItem].self) { category in
				
				try category.optionItems.query(on: req).all()
		}
	}
	
	
	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(LineDecorCategory.self), req.parameters.next(DecorItem.self))
		{ category, optionItem in
			
			return category.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[DecorItem]> {
		
		return try req.parameters.next(LineDecorCategory.self).flatMap(to: [DecorItem].self) { category in
			
			try category.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(LineDecorCategory.self), req.parameters.next(DecorItem.self)) { category, optionItem in
			
			return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}
	
}





