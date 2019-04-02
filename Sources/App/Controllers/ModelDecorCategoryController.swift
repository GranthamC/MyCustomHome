import Vapor
import Fluent
import Authentication


struct ModelDecorCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "model-decor-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(HM_DecorCategory.parameter, use: getHandler)
		
		homeOptionsCategoriesRoute.get(HM_DecorCategory.parameter, "home-model", use: getHomeModelHandler)
		
		homeOptionsCategoriesRoute.get(HM_DecorCategory.parameter, "decor-items", use: getCategoryItemsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(HM_DecorCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(HM_DecorCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HM_DecorCategory.parameter, use: updateHandler)
		
		tokenAuthGroup.post(HM_DecorCategory.parameter, "decor-item", DecorItem.parameter, use: addOptionItemHandler)
		
		tokenAuthGroup.delete(HM_DecorCategory.parameter, "decor-item", DecorItem.parameter, use: removeOptionItemHandler)
	}
	
	
	func createHandler(
		_ req: Request,
		category: HM_DecorCategory
		) throws -> Future<HM_DecorCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[HM_DecorCategory]>
	{
		return HM_DecorCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<HM_DecorCategory>
	{
		return try req.parameters.next(HM_DecorCategory.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HM_DecorCategory> {
		
		return try flatMap(
			to: HM_DecorCategory.self,
			req.parameters.next(HM_DecorCategory.self),
			req.content.decode(HM_DecorCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.modelID = updatedCategory.modelID
			category.optionType = updatedCategory.optionType
			category.changeToken = updatedCategory.changeToken
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HM_DecorCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the product line record for this category
	//
	func getHomeModelHandler(_ req: Request) throws -> Future<HomeModel> {
		
		return try req.parameters.next(HM_DecorCategory.self).flatMap(to: HomeModel.self) { category in
			
			category.homeModel.get(on: req)
		}
	}
	
	
	// Get the category options for this category
	//
	func getCategoryItemsHandler(_ req: Request) throws -> Future<[DecorItem]> {
		
		return try req
			.parameters.next(HM_DecorCategory.self)
			.flatMap(to: [DecorItem].self) { category in
				
				try category.optionItems.query(on: req).all()
		}
	}
	
	
	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(HM_DecorCategory.self), req.parameters.next(DecorItem.self))
		{ category, optionItem in
			
			return category.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[DecorItem]> {
		
		return try req.parameters.next(HM_DecorCategory.self).flatMap(to: [DecorItem].self) { category in
			
			try category.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(HM_DecorCategory.self), req.parameters.next(DecorItem.self)) { category, optionItem in
			
			return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}
	
}






