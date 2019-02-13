import Vapor
import Fluent
import Authentication


struct HomeOptionCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "option-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(OptionCategory.parameter, use: getHandler)

		homeOptionsCategoriesRoute.get(OptionCategory.parameter, "builder", use: getBuilderHandler)
		
		homeOptionsCategoriesRoute.get(OptionCategory.parameter, "option-item", use: getOptionItemHandler)

		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(OptionCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(OptionCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(OptionCategory.parameter, use: updateHandler)
		
		tokenAuthGroup.post(OptionCategory.parameter, "option-item", OptionItem.parameter, use: addOptionItemHandler)
		
		tokenAuthGroup.delete(OptionCategory.parameter, "option-item", OptionItem.parameter, use: removeOptionItemHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		category: OptionCategory
		) throws -> Future<OptionCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[OptionCategory]>
	{
		return OptionCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<OptionCategory>
	{
		return try req.parameters.next(OptionCategory.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<OptionCategory> {
		
		return try flatMap(
			to: OptionCategory.self,
			req.parameters.next(OptionCategory.self),
			req.content.decode(OptionCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.builderID = updatedCategory.builderID
			category.optionType = updatedCategory.optionType
			category.changeToken = updatedCategory.changeToken

			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(OptionCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}

	
	// Get the Builder record for this category
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(OptionCategory.self).flatMap(to: HomeBuilder.self) { category in
			
			category.builder.get(on: req)
		}
	}


	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(OptionCategory.self), req.parameters.next(OptionItem.self))
		{ category, optionItem in
			
			return category.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[OptionItem]> {
		
		return try req.parameters.next(OptionCategory.self).flatMap(to: [OptionItem].self) { category in
			
			try category.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(OptionCategory.self), req.parameters.next(OptionItem.self)) { category, optionItem in
			
			return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}

}



