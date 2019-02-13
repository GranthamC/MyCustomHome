import Vapor
import Fluent
import Authentication


struct DecorPackageController: RouteCollection
{
	func boot(router: Router) throws {
		
		let decorPackageRoutes = router.grouped("api", "decor-package")
		
		decorPackageRoutes.get(use: getAllHandler)
		
		decorPackageRoutes.get(DecorPackage.parameter, use: getHandler)
		
		decorPackageRoutes.get(DecorPackage.parameter, "builder", use: getBuilderHandler)
		
		decorPackageRoutes.get(DecorPackage.parameter, "decor-items", use: getOptionItemHandler)
		
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = decorPackageRoutes.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(DecorPackage.self, use: createHandler)
		
		tokenAuthGroup.delete(DecorPackage.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(DecorPackage.parameter, use: updateHandler)
		
		tokenAuthGroup.post(DecorPackage.parameter, "decor-item", DecorItem.parameter, use: addOptionItemHandler)
		
		tokenAuthGroup.delete(DecorPackage.parameter, "decor-item", DecorItem.parameter, use: removeOptionItemHandler)
		
	}
	
	
	func createHandler(
		_ req: Request,
		decorPkg: DecorPackage
		) throws -> Future<DecorPackage> {
		
		return decorPkg.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[DecorPackage]>
	{
		return DecorPackage.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<DecorPackage>
	{
		return try req.parameters.next(DecorPackage.self)
	}
	
	
	// Update passed decorPkg with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<DecorPackage> {
		
		return try flatMap(
			to: DecorPackage.self,
			req.parameters.next(DecorPackage.self),
			req.content.decode(DecorPackage.self)
		) { decorPkg, updatedCategory in
			decorPkg.name = updatedCategory.name
			decorPkg.builderID = updatedCategory.builderID
			decorPkg.changeToken = updatedCategory.changeToken
			return decorPkg.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(DecorPackage.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the Builder record for this decorPkg
	//
	func getBuilderHandler(_ req: Request) throws -> Future<HomeBuilder> {
		
		return try req.parameters.next(DecorPackage.self).flatMap(to: HomeBuilder.self) { decorPkg in
			
			decorPkg.builder.get(on: req)
		}
	}
	
	
	
	func addOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus>
	{
		
		return try flatMap(to: HTTPStatus.self,	req.parameters.next(DecorPackage.self), req.parameters.next(DecorItem.self))
		{ decorPkg, optionItem in
			
			return decorPkg.optionItems.attach(optionItem, on: req).transform(to: .created)
		}
	}
	
	// Get the line's home models
	//
	func getOptionItemHandler(_ req: Request) throws -> Future<[DecorItem]> {
		
		return try req.parameters.next(DecorPackage.self).flatMap(to: [DecorItem].self) { decorPkg in
			
			try decorPkg.optionItems.query(on: req).all()
		}
	}
	
	func removeOptionItemHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try flatMap(to: HTTPStatus.self, req.parameters.next(DecorPackage.self), req.parameters.next(DecorItem.self)) { decorPkg, optionItem in
			
			return decorPkg.optionItems.detach(optionItem, on: req).transform(to: .noContent)
		}
	}
	
}




