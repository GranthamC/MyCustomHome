
import Vapor
import Fluent
import Authentication


struct SetCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeSetRoute = router.grouped("api", "set-category")
		
		homeSetRoute.get(use: getAllHandler)
		
		homeSetRoute.get(HomeSetCategory.parameter, use: getHandler)
		
		homeSetRoute.get(HomeSetCategory.parameter, "home-set", use: getHomeSetHandler)
		
		homeSetRoute.get(HomeSetCategory.parameter, "home-models", use: getHomeModelsHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeSetRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		tokenAuthGroup.post(HomeSetCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(HomeSetCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HomeSetCategory.parameter, use: updateHandler)
		
		tokenAuthGroup.post(HomeSetCategory.parameter, "home-model", HomeModel.parameter, use: addHomeModelHandler)
		
		tokenAuthGroup.delete(HomeSetCategory.parameter, "home-model", HomeModel.parameter, use: removeHomeModelHandler)
	}
	
	
	func createHandler(_ req: Request, line: HomeSetCategory) throws -> Future<HomeSetCategory> {
		
		return line.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[HomeSetCategory]>
	{
		return HomeSetCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<HomeSetCategory>
	{
		return try req.parameters.next(HomeSetCategory.self)
	}
	
	
	// Update passed product line with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HomeSetCategory> {
		
		return try flatMap(
			to: HomeSetCategory.self,
			req.parameters.next(HomeSetCategory.self),
			req.content.decode(HomeSetCategory.self)
		) { category, updatedCategory in
			
			category.name = updatedCategory.name
			
			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HomeSetCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the home set record for this category
	//
	func getHomeSetHandler(_ req: Request) throws -> Future<HomeModelSet> {
		
		return try req
			.parameters.next(HomeSetCategory.self)
			.flatMap(to: HomeModelSet.self) { line in
				
				line.homeSet.get(on: req)
		}
	}
	
	
	func addHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(HomeSetCategory.self), req.parameters.next(HomeModel.self))
		{ line, model in
			
			return line.homeModels.attach(model, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getHomeModelsHandler(_ req: Request) throws -> Future<[HomeModel]> {
		
		return try req.parameters.next(HomeSetCategory.self).flatMap(to: [HomeModel].self) { line in
			
			try line.homeModels.query(on: req).all()
		}
	}
	
	func removeHomeModelHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(HomeSetCategory.self), req.parameters.next(HomeModel.self)) { line, model in
			
			return line.homeModels.detach(model, on: req).transform(to: .noContent)
		}
	}
	
}



