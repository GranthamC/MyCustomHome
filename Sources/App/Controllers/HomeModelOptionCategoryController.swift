
import Vapor
import Fluent
import Authentication



struct HomeModelOptionCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeModelCategoriesRoute = router.grouped("api", "model-option-category")
		
		homeModelCategoriesRoute.get(use: getAllHandler)
		
		homeModelCategoriesRoute.get(HomeModelOptionCategory.parameter, use: getHandler)
		
		homeModelCategoriesRoute.get(HomeModelOptionCategory.parameter, "model", use: getHomeModelHandler)
		
		homeModelCategoriesRoute.get(HomeModelOptionCategory.parameter, "model-option-items", use: getModelOptionItemsHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeModelCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(HomeModelOptionCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(HomeModelOptionCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HomeModelOptionCategory.parameter, use: updateHandler)
		
	}
	
	
	func createHandler(_ req: Request, category: HomeModelOptionCategory) throws -> Future<HomeModelOptionCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[HomeModelOptionCategory]>
	{
		return HomeModelOptionCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<HomeModelOptionCategory>
	{
		return try req.parameters.next(HomeModelOptionCategory.self)
	}
	
	
	// Update passed product category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HomeModelOptionCategory> {
		
		return try flatMap(
			to: HomeModelOptionCategory.self,
			req.parameters.next(HomeModelOptionCategory.self),
			req.content.decode(HomeModelOptionCategory.self)
		) { category, updatedCategory in
			category.homeModelID = updatedCategory.homeModelID
			category.categoryID = updatedCategory.categoryID
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HomeModelOptionCategory.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the Builder record for this product category
	//
	func getHomeModelHandler(_ req: Request) throws -> Future<HomeModel> {
		
		return try req.parameters.next(HomeModelOptionCategory.self).flatMap(to: HomeModel.self) { category in
			
			category.homeModel.get(on: req)
		}
	}
	
	
	func getModelOptionItemsHandler(_ req: Request) throws -> Future<[HomeModelOptionItem]> {
		
		return try req.parameters.next(HomeModelOptionCategory.self).flatMap(to: [HomeModelOptionItem].self) { category in
			
			try category.modelOptions.query(on: req).all()
		}
	}
	
	
}




