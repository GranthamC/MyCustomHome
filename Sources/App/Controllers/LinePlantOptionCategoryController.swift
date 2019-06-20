import Vapor
import Fluent
import Authentication


struct LinePlantOptionCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "line-builder-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(LineOptionCategory.parameter, use: getHandler)
		
		homeOptionsCategoriesRoute.get(LineOptionCategory.parameter, "line", use: getProductLineHandler)
		
		homeOptionsCategoriesRoute.get(LineOptionCategory.parameter, "builder-category", use: getBuilderCategoryHandler)
		
		homeOptionsCategoriesRoute.get(LineOptionCategory.parameter, "builder-options", use: getCategoryItemsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(LineOptionCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(LineOptionCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(LineOptionCategory.parameter, use: updateHandler)
		
		tokenAuthGroup.post(LineOptionCategory.parameter, "builder-option", BuilderOption.parameter, use: addOptionItemHandler)
		
		tokenAuthGroup.delete(LineOptionCategory.parameter, "builder-option", BuilderOption.parameter, use: removeOptionItemHandler)
	}
	
	
	func createHandler(
		_ req: Request,
		category: LineOptionCategory
		) throws -> Future<LineOptionCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[LineOptionCategory]>
	{
		return LineOptionCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<LineOptionCategory>
	{
		return try req.parameters.next(LineOptionCategory.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<LineOptionCategory> {
		
		return try flatMap(
			to: LineOptionCategory.self,
			req.parameters.next(LineOptionCategory.self),
			req.content.decode(LineOptionCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.lineID = updatedCategory.lineID
			category.categoryID = updatedCategory.categoryID
			category.optionType = updatedCategory.optionType
			category.changeToken = updatedCategory.changeToken
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(LineOptionCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the product line record for this category
	//
	func getProductLineHandler(_ req: Request) throws -> Future<Line> {
		
		return try req.parameters.next(LineOptionCategory.self).flatMap(to: Line.self) { category in
			
			category.productLine.get(on: req)
		}
	}
	
	
	// Get the product line record for this category
	//
	func getBuilderCategoryHandler(_ req: Request) throws -> Future<PlantCategory> {
		
		return try req.parameters.next(LineOptionCategory.self).flatMap(to: PlantCategory.self) { category in
			
			category.builderCategory.get(on: req)
		}
	}
	
	
	// Get the category options for this category
	//
	func getCategoryItemsHandler(_ req: Request) throws -> Future<[BuilderOption]> {
		
		return try req
			.parameters.next(LineOptionCategory.self)
			.flatMap(to: [BuilderOption].self) { category in
				
				try category.optionItems.query(on: req).all()
		}
	}
	
	
	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(LineOptionCategory.self), req.parameters.next(BuilderOption.self))
		{ category, optionItem in
			
			return category.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[BuilderOption]> {
		
		return try req.parameters.next(LineOptionCategory.self).flatMap(to: [BuilderOption].self) { category in
			
			try category.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(LineOptionCategory.self), req.parameters.next(BuilderOption.self)) { category, optionItem in
			
			return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}
	
}






