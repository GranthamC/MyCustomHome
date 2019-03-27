import Vapor
import Fluent
import Authentication


struct ModelDecorCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "model-decor-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(ModelDecorCategory.parameter, use: getHandler)
		
		homeOptionsCategoriesRoute.get(ModelDecorCategory.parameter, "line", use: getProductLineHandler)
		
		homeOptionsCategoriesRoute.get(ModelDecorCategory.parameter, "decor-items", use: getCategoryItemsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(ModelDecorCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(ModelDecorCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(ModelDecorCategory.parameter, use: updateHandler)
		
		tokenAuthGroup.post(ModelDecorCategory.parameter, "decor-item", DecorCategory.parameter, use: addOptionItemHandler)
		
		tokenAuthGroup.delete(ModelDecorCategory.parameter, "decor-item", DecorCategory.parameter, use: removeOptionItemHandler)
	}
	
	
	func createHandler(
		_ req: Request,
		category: ModelDecorCategory
		) throws -> Future<ModelDecorCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[ModelDecorCategory]>
	{
		return ModelDecorCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<ModelDecorCategory>
	{
		return try req.parameters.next(ModelDecorCategory.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<ModelDecorCategory> {
		
		return try flatMap(
			to: ModelDecorCategory.self,
			req.parameters.next(ModelDecorCategory.self),
			req.content.decode(ModelDecorCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.modelID = updatedCategory.modelID
			category.optionType = updatedCategory.optionType
			category.changeToken = updatedCategory.changeToken
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(ModelDecorCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the product line record for this category
	//
	func getProductLineHandler(_ req: Request) throws -> Future<HomeModel> {
		
		return try req.parameters.next(ModelDecorCategory.self).flatMap(to: HomeModel.self) { category in
			
			category.homeModel.get(on: req)
		}
	}
	
	
	// Get the category options for this category
	//
	func getCategoryItemsHandler(_ req: Request) throws -> Future<[DecorItem]> {
		
		return try req
			.parameters.next(ModelDecorCategory.self)
			.flatMap(to: [DecorItem].self) { category in
				
				try category.optionItems.query(on: req).all()
		}
	}
	
	
	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(ModelDecorCategory.self), req.parameters.next(DecorItem.self))
		{ category, optionItem in
			
			return category.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[DecorItem]> {
		
		return try req.parameters.next(ModelDecorCategory.self).flatMap(to: [DecorItem].self) { category in
			
			try category.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(ModelDecorCategory.self), req.parameters.next(DecorItem.self)) { category, optionItem in
			
			return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}
	
}






