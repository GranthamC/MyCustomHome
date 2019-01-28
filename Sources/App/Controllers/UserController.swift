import Vapor
import Fluent
import Crypto

struct UserController: RouteCollection
{
	func boot(router: Router) throws {
		
		let usersRoute = router.grouped("api", "user")
		
//		usersRoute.post(User.self, use: createHandler)
		
//		usersRoute.get(use: getAllHandler)
		
//		usersRoute.get(User.parameter, use: getHandler)
		
//		usersRoute.put(User.parameter, use: updateHandler)
		
//		usersRoute.delete(User.parameter, use: deleteHandler)
		
//		usersRoute.get("search", use: searchHandler)
		
//		usersRoute.get("first", use: getFirstHandler)

//		usersRoute.get("sorted", use: sortedHandler)
		
		let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
		
		let basicAuthGroup = usersRoute.grouped(basicAuthMiddleware)
		
		basicAuthGroup.post("login", use: loginHandler)

		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = usersRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)
		
		tokenAuthGroup.get("logout", use: logoutHandler)

		tokenAuthGroup.post(User.self, use: createHandler)
		
		tokenAuthGroup.delete(User.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(User.parameter, use: updateHandler)
		
		tokenAuthGroup.put(User.parameter, use: getHandler)

		tokenAuthGroup.get("search", use: searchHandler)

		tokenAuthGroup.get(use: getAllHandler)

	}
	
	
	func createHandler(_ req: Request, user: User) throws -> Future<User.Public> {
		
		user.password = try BCrypt.hash(user.password)
		
		return user.save(on: req).convertToPublic()
	}
	
	
	func loginHandler(_ req: Request) throws -> Future<Token>
	{
		let user = try req.requireAuthenticated(User.self)
		
		// If old token, delete and generate a new one and return it
		//
		_ = try Token.query(on: req).filter(\Token.userID, .equal, user.requireID()).delete().flatMap { _ -> EventLoopFuture<Token> in
			
			let token = try Token.generate(for: user)
			
			return token.save(on: req)
		}

		let token = try Token.generate(for: user)
		
		return token.save(on: req)
	}

	func logoutHandler(_ req: Request) throws -> Future<HTTPResponse> {
		
		let user = try req.requireAuthenticated(User.self)
		
		return try Token
			.query(on: req)
			.filter(\Token.userID, .equal, user.requireID())
			.delete()
			.transform(to: HTTPResponse(status: .ok))
	}

	
	func getAllHandler(_ req: Request) throws -> Future<[User.Public]> {
		
		return User.query(on: req).decode(data: User.Public.self).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<User.Public>
	{
		return try req.parameters.next(User.self).convertToPublic()
	}
	
	// Update passed user with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<User> {
		
		return try flatMap(to: User.self, req.parameters.next(User.self), req.content.decode(User.self)) { user, updatedUser in

			user.name = updatedUser.name
			
			user.username = updatedUser.username

			user.password = try BCrypt.hash(updatedUser.password)

			return user.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(User.self)
			.delete(on: req)
			.transform(to: HTTPStatus.noContent)
	}
	
	
	func searchHandler(_ req: Request) throws -> Future<[User.Public]>
	{
		guard let searchTerm = req.query[String.self, at: "param"] else {
			throw Abort(.badRequest)
		}
		
		return User.query(on: req).group(.or) { or in
			or.filter(\.name == searchTerm)
			or.filter(\.username == searchTerm)
			}.decode(data: User.Public.self).all()
	}
	
	
	func getFirstHandler(_ req: Request) throws -> Future<User>
	{
		return User.query(on: req)
			.first()
			
			.map(to: User.self) { homebuilder in
				guard let homebuilder = homebuilder else {
					throw Abort(.notFound)
				}
				
				return homebuilder
		}
	}
	

	func sortedHandler(_ req: Request) throws -> Future<[User]>
	{
		return User.query(on: req).sort(\.name, .ascending).all()
	}
}


