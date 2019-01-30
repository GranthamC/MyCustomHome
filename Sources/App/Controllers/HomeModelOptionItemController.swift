
import Vapor
import Fluent
import Authentication


struct HomeModelOptionItemController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let modelOptionItemsRoute = router.grouped("api", "model-option-item")
		
		modelOptionItemsRoute.get(use: getAllHandler)
		
		modelOptionItemsRoute.get(HomeModelOptionItem.parameter, use: getHandler)
		
		modelOptionItemsRoute.get("search", use: searchHandler)
		
		modelOptionItemsRoute.get("first", use: getFirstHandler)
		
		modelOptionItemsRoute.get("sorted", use: sortedHandler)
		
		modelOptionItemsRoute.get(HomeModelOptionItem.parameter, "line-decor-category", use: getCategoryHandler)
		
		modelOptionItemsRoute.get(HomeModelOptionItem.parameter, "decor-item", use: getOptionItemHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = modelOptionItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(HomeModelOptionItem.self, use: createHandler)
		
		tokenAuthGroup.delete(HomeModelOptionItem.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(HomeModelOptionItem.parameter, use: updateHandler)
	}
	
	
	func createHandler(_ req: Request, optionItem: HomeModelOptionItem) throws -> Future<HomeModelOptionItem> {
		
		return optionItem.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[HomeModelOptionItem]>
	{
		return HomeModelOptionItem.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<HomeModelOptionItem>
	{
		return try req.parameters.next(HomeModelOptionItem.self)
	}
	
	
	// Update passed product decor Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<HomeModelOptionItem> {
		
		return try flatMap(
			to: HomeModelOptionItem.self,
			req.parameters.next(HomeModelOptionItem.self),
			req.content.decode(HomeModelOptionItem.self)
		) { optionItem, updatedItem in
			optionItem.name = updatedItem.name
			optionItem.itemID = updatedItem.itemID
			optionItem.categoryID = updatedItem.categoryID
			
			return optionItem.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(HomeModelOptionItem.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}
	
	
	func searchHandler(_ req: Request) throws -> Future<[HomeModelOptionItem]>
	{
		guard let searchTerm = req.query[String.self, at: "param"] else {
			throw Abort(.badRequest)
		}
		
		return HomeModelOptionItem.query(on: req).group(.or) { or in
			or.filter(\.name == searchTerm)
			}.all()
	}
	
	
	func getFirstHandler(_ req: Request) throws -> Future<HomeModelOptionItem>
	{
		return HomeModelOptionItem.query(on: req)
			.first()
			
			.map(to: HomeModelOptionItem.self) { optionItem in
				guard let item = optionItem else {
					throw Abort(.notFound)
				}
				
				return item
		}
	}
	
	
	func sortedHandler(_ req: Request) throws -> Future<[HomeModelOptionItem]>
	{
		return HomeModelOptionItem.query(on: req).sort(\.name, .ascending).all()
	}
	
	// Get the Category record for this decor Item
	//
	func getCategoryHandler(_ req: Request) throws -> Future<HomeModelOptionCategory> {
		
		return try req
			.parameters.next(HomeModelOptionItem.self)
			.flatMap(to: HomeModelOptionCategory.self) { optionItem in
				
				optionItem.modelCategory.get(on: req)
		}
	}
	
	// Get the category record for this decor Item
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<HomeOptionItem> {
		
		return try req.parameters.next(HomeModelOptionItem.self).flatMap(to: HomeOptionItem.self) { optionItem in
			
			optionItem.homeOption.get(on: req)
		}
	}
	
}





