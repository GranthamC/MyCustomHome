import Vapor
import Fluent
import Authentication


struct ModelOptionCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "model-option-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(ModelOptionCategory.parameter, use: getHandler)
		
		homeOptionsCategoriesRoute.get(ModelOptionCategory.parameter, "home-model", use: getHomeModelHandler)
		
		homeOptionsCategoriesRoute.get(ModelOptionCategory.parameter, "option-items", use: getCategoryOptionsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(ModelOptionCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(ModelOptionCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(ModelOptionCategory.parameter, use: updateHandler)
		
	}
	
	
	func createHandler(
		_ req: Request,
		category: ModelOptionCategory
		) throws -> Future<ModelOptionCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[ModelOptionCategory]>
	{
		return ModelOptionCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<ModelOptionCategory>
	{
		return try req.parameters.next(ModelOptionCategory.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<ModelOptionCategory> {
		
		return try flatMap(
			to: ModelOptionCategory.self,
			req.parameters.next(ModelOptionCategory.self),
			req.content.decode(ModelOptionCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.modelID = updatedCategory.modelID
			category.optionType = updatedCategory.optionType
			category.changeToken = updatedCategory.changeToken
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(ModelOptionCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the Builder record for this category
	//
	func getHomeModelHandler(_ req: Request) throws -> Future<HomeModel> {
		
		return try req.parameters.next(ModelOptionCategory.self).flatMap(to: HomeModel.self) { category in
			
			category.homeModel.get(on: req)
		}
	}
	
	
	// Get the category options for this category
	//
	func getCategoryOptionsHandler(_ req: Request) throws -> Future<[ModelOption]> {
		
		return try req
			.parameters.next(ModelOptionCategory.self)
			.flatMap(to: [ModelOption].self) { category in
				
				try category.optionItems.query(on: req).all()
		}
	}
	
	
	/*
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
	
	return try flatMap(to: HTTPStatus.self,	req.parameters.next(ModelOptionCategory.self), req.parameters.next(ModelOption.self))
	{ category, optionItem in
	
	return category.optionItems.attach(optionItem, on: req).transform(to: .created)
	}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[ModelOption]> {
	
	return try req.parameters.next(ModelOptionCategory.self).flatMap(to: [ModelOption].self) { category in
	
	try category.optionItems.query(on: req).all()
	}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
	
	return try flatMap(to: HTTPStatus.self, req.parameters.next(ModelOptionCategory.self), req.parameters.next(ModelOption.self)) { category, optionItem in
	
	return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
	}
	}
	*/
}





