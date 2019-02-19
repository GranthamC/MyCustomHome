import Vapor
import Fluent
import Authentication


struct ChangeTokenController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let changeTokenRoutes = router.grouped("api", "change-token")
		
		changeTokenRoutes.get(use: getAllHandler)
		
		changeTokenRoutes.get(ChangeToken.parameter, use: getHandler)
		
		changeTokenRoutes.get(ChangeToken.parameter, "builder", use: getGetBuilderHandler)

		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = changeTokenRoutes.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(ChangeToken.self, use: createHandler)
		
		tokenAuthGroup.delete(ChangeToken.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(ChangeToken.parameter, use: updateHandler)		
	}
	
	
	func createHandler(	_ req: Request, changeToken: ChangeToken ) throws -> Future<ChangeToken> {
		
		return changeToken.save(on: req)
	}
	
	func getAllHandler(_ req: Request) throws -> Future<[ChangeToken]>
	{
		return ChangeToken.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<ChangeToken>
	{
		return try req.parameters.next(ChangeToken.self)
	}
	
	
	// Update passed category with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<ChangeToken> {
		
		return try flatMap(
			to: ChangeToken.self,
			req.parameters.next(ChangeToken.self),
			req.content.decode(ChangeToken.self)
		) { tokens, updatedTokens in
			tokens.builderName = updatedTokens.builderName
			tokens.builderID = updatedTokens.builderID
			tokens.builderToken = updatedTokens.builderToken
			tokens.decorItemToken = updatedTokens.decorItemToken
			tokens.decorPackageToken = updatedTokens.decorPackageToken
			tokens.decorCategoryToken = updatedTokens.decorCategoryToken
			tokens.homeModelToken = updatedTokens.homeModelToken
			tokens.homeOptionToken = updatedTokens.homeOptionToken
			tokens.homeOptionCategoryToken = updatedTokens.homeOptionCategoryToken
			tokens.imageAssetToken = updatedTokens.imageAssetToken
			tokens.productLineToken = updatedTokens.productLineToken
			return tokens.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(ChangeToken.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	// Get the tokens builder
	//
	func getGetBuilderHandler(_ req: Request) throws -> Future<[HomeBuilder]> {
		
		return try req.parameters.next(ChangeToken.self).flatMap(to: [HomeBuilder].self) { tokens in
			
			try tokens.builder.query(on: req).all()
		}
	}
	
}



