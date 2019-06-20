import Vapor
import Fluent
import Authentication


struct PlantCategoryController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let homeOptionsCategoriesRoute = router.grouped("api", "builder-option-category")
		
		homeOptionsCategoriesRoute.get(use: getAllHandler)
		
		homeOptionsCategoriesRoute.get(PlantCategory.parameter, use: getHandler)

		homeOptionsCategoriesRoute.get(PlantCategory.parameter, "builder", use: getBuilderHandler)
		
		homeOptionsCategoriesRoute.get(PlantCategory.parameter, "option-items", use: getCategoryOptionsHandler)

		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = homeOptionsCategoriesRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(PlantCategory.self, use: createHandler)
		
		tokenAuthGroup.delete(PlantCategory.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(PlantCategory.parameter, use: updateHandler)

	}
	
	
	func createHandler(
		_ req: Request,
		category: PlantCategory
		) throws -> Future<PlantCategory> {
		
		return category.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[PlantCategory]>
	{
		return PlantCategory.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<PlantCategory>
	{
		return try req.parameters.next(PlantCategory.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<PlantCategory> {
		
		return try flatMap(
			to: PlantCategory.self,
			req.parameters.next(PlantCategory.self),
			req.content.decode(PlantCategory.self)
		) { category, updatedCategory in
			category.name = updatedCategory.name
			category.plantID = updatedCategory.plantID
			category.optionType = updatedCategory.optionType
			category.changeToken = updatedCategory.changeToken

			return category.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(PlantCategory.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the category options for this category
	//
	func getCategoryOptionsHandler(_ req: Request) throws -> Future<[BuilderOption]> {
		
		return try req
			.parameters.next(PlantCategory.self)
			.flatMap(to: [BuilderOption].self) { category in
				
				try category.categoryOptions.query(on: req).all()
		}
	}

	
	// Get the Builder record for this category
	//
	func getBuilderHandler(_ req: Request) throws -> Future<Plant> {
		
		return try req.parameters.next(PlantCategory.self).flatMap(to: Plant.self) { category in
			
			category.builder.get(on: req)
		}
	}


	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(PlantCategory.self), req.parameters.next(BuilderOption.self))
		{ category, optionItem in
			
			return category.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[BuilderOption]> {
		
		return try req.parameters.next(PlantCategory.self).flatMap(to: [BuilderOption].self) { category in
			
			try category.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(PlantCategory.self), req.parameters.next(BuilderOption.self)) { category, optionItem in
			
			return category.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}

}



