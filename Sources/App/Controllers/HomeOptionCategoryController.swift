import Vapor
import Fluent
import Authentication


struct HomeOptionCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "home-option-category")
		
//		homeOptionsCategoriesRoute.post(HomeOptionCategory.self, use: createHandler)
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(HomeOptionCategory.parameter, use: getHandler)
		
//		homeOptionsCategoriesRoute.put(HomeOptionCategory.parameter, use: updateHandler)

//		homeOptionsCategoriesRoute.delete(HomeOptionCategory.parameter, use: deleteHandler)

		homeOptionsCategoriesRoute.get(HomeOptionCategory.parameter, "builder", use: getBuilderHandler)
		
		homeOptionsCategoriesRoute.get(DecorOptionCategory.parameter, "home-option-items", use: getHomeOptionItemsHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(HomeOptionCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(HomeOptionCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HomeOptionCategory.parameter, use: updateHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		category: HomeOptionCategory
		) throws -> Future<HomeOptionCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[HomeOptionCategory]>
	{
		return HomeOptionCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<HomeOptionCategory>
	{
		return try req.parameters.next(HomeOptionCategory.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HomeOptionCategory> {
		
		return try flatMap(
			to: HomeOptionCategory.self,
			req.parameters.next(HomeOptionCategory.self),
			req.content.decode(HomeOptionCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.builderID = updatedCategory.builderID
			category.optionType = updatedCategory.optionType
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HomeOptionCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}

	
	// Get the Builder record for this category
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(HomeOptionCategory.self).flatMap(to: HomeBuilder.self) { category in
			
			category.builder.get(on: req)
		}
	}
	
	
	func getHomeOptionItemsHandler(_ req: Request) throws -> Future<[HomeOptionItem]> {

		return try req.parameters.next(HomeOptionCategory.self).flatMap(to: [HomeOptionItem].self) { category in
			
			try category.homeOptions.query(on: req).all()
		}
	}

	
}



