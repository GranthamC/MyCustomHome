import Vapor
import Fluent
import Authentication


struct ModelBuilderCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "model-builder-option-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(HM_BdrOptCategory.parameter, use: getHandler)
		
		homeOptionsCategoriesRoute.get(HM_BdrOptCategory.parameter, "home-model", use: getHomeModelHandler)
		
		homeOptionsCategoriesRoute.get(HM_BdrOptCategory.parameter, "builder-options", use: getCategoryItemsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(HM_BdrOptCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(HM_BdrOptCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HM_BdrOptCategory.parameter, use: updateHandler)
		
		tokenAuthGroup.post(HM_BdrOptCategory.parameter, "builder-option", BuilderOption.parameter, use: addOptionItemHandler)
		
		tokenAuthGroup.delete(HM_BdrOptCategory.parameter, "builder-option", BuilderOption.parameter, use: removeOptionItemHandler)
	}
	
	
	func createHandler(
		_ req: Request,
		category: HM_BdrOptCategory
		) throws -> Future<HM_BdrOptCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[HM_BdrOptCategory]>
	{
		return HM_BdrOptCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<HM_BdrOptCategory>
	{
		return try req.parameters.next(HM_BdrOptCategory.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HM_BdrOptCategory> {
		
		return try flatMap(
			to: HM_BdrOptCategory.self,
			req.parameters.next(HM_BdrOptCategory.self),
			req.content.decode(HM_BdrOptCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.modelID = updatedCategory.modelID
			category.categoryID = updatedCategory.categoryID
			category.optionType = updatedCategory.optionType
			category.changeToken = updatedCategory.changeToken
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HM_BdrOptCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the product line record for this category
	//
	func getHomeModelHandler(_ req: Request) throws -> Future<HomeModel> {
		
		return try req.parameters.next(HM_BdrOptCategory.self).flatMap(to: HomeModel.self) { category in
			
			category.homeModel.get(on: req)
		}
	}
	
	
	// Get the category options for this category
	//
	func getCategoryItemsHandler(_ req: Request) throws -> Future<[BuilderOption]> {
		
		return try req
			.parameters.next(HM_BdrOptCategory.self)
			.flatMap(to: [BuilderOption].self) { category in
				
				try category.optionItems.query(on: req).all()
		}
	}
	
	
	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(HM_BdrOptCategory.self), req.parameters.next(BuilderOption.self))
		{ category, optionItem in
			
			return category.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[BuilderOption]> {
		
		return try req.parameters.next(HM_BdrOptCategory.self).flatMap(to: [BuilderOption].self) { category in
			
			try category.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(HM_BdrOptCategory.self), req.parameters.next(BuilderOption.self)) { category, optionItem in
			
			return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}
	
}







