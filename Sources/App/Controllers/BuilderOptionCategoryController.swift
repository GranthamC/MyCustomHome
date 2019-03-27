import Vapor
import Fluent
import Authentication


struct BuilderOptionCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "builder-option-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(BuilderOptionCategory.parameter, use: getHandler)

		homeOptionsCategoriesRoute.get(BuilderOptionCategory.parameter, "builder", use: getBuilderHandler)
		
		homeOptionsCategoriesRoute.get(BuilderOptionCategory.parameter, "option-items", use: getCategoryOptionsHandler)

		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(BuilderOptionCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(BuilderOptionCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(BuilderOptionCategory.parameter, use: updateHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		category: BuilderOptionCategory
		) throws -> Future<BuilderOptionCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[BuilderOptionCategory]>
	{
		return BuilderOptionCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<BuilderOptionCategory>
	{
		return try req.parameters.next(BuilderOptionCategory.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<BuilderOptionCategory> {
		
		return try flatMap(
			to: BuilderOptionCategory.self,
			req.parameters.next(BuilderOptionCategory.self),
			req.content.decode(BuilderOptionCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.builderID = updatedCategory.builderID
			category.optionType = updatedCategory.optionType
			category.changeToken = updatedCategory.changeToken

			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(BuilderOptionCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the category options for this category
	//
	func getCategoryOptionsHandler(_ req: Request) throws -> Future<[BuilderOptionItem]> {
		
		return try req
			.parameters.next(BuilderOptionCategory.self)
			.flatMap(to: [BuilderOptionItem].self) { category in
				
				try category.categoryOptions.query(on: req).all()
		}
	}

	
	// Get the Builder record for this category
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(BuilderOptionCategory.self).flatMap(to: HomeBuilder.self) { category in
			
			category.builder.get(on: req)
		}
	}


	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(BuilderOptionCategory.self), req.parameters.next(BuilderOptionItem.self))
		{ category, optionItem in
			
			return category.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[BuilderOptionItem]> {
		
		return try req.parameters.next(BuilderOptionCategory.self).flatMap(to: [BuilderOptionItem].self) { category in
			
			try category.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(BuilderOptionCategory.self), req.parameters.next(BuilderOptionItem.self)) { category, optionItem in
			
			return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}

}



