import Foundation
import Vapor
import FluentPostgreSQL
import Authentication


final class User: Codable
{
	var id: UUID?
	
	var name: String
	var username: String
	var password: String
	
	var superUser: Bool?
	var adminUser: Bool?

	init(name: String, username: String, password: String) {
		self.name = name
		self.username = username
		self.password = password
		
		self.superUser = false
		self.adminUser = false
	}
	
	final class Public: Codable {
		var id: UUID?
		var name: String
		var username: String
		
		init(id: UUID?, name: String, userName: String) {
			
			self.id = id
			self.username = userName
			self.name = name
		}
	}
}

extension User: PostgreSQLUUIDModel {}

extension User: Migration
{
	static func prepare(on connection: PostgreSQLConnection)
		-> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.unique(on: \.username)
		}
	}

}

extension User: Content {}

extension User: Parameter {}

extension User
{
	func convertToPublic() -> User.Public
	{
		return User.Public(id: id, name: name, userName: username)
	}
}


extension User.Public: Content {}


extension Future where T: User
{
	func convertToPublic() -> Future<User.Public>
	{
		return self.map(to: User.Public.self) { user in
			
			return user.convertToPublic()
		}
	}
}


extension User: BasicAuthenticatable
{
	static let usernameKey: UsernameKey = \User.username

	static let passwordKey: PasswordKey = \User.password
}


extension User: TokenAuthenticatable
{
	typealias TokenType = Token
}

struct AdminUser: Migration
{
	typealias Database = PostgreSQLDatabase
	
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
//		let adminName = Environment.get("MCH_ADMIN_USER")
//
//		let adminPassword = Environment.get("MCH_ADMIN_PASSWORD")

		let password = try? BCrypt.hash(adminPassword!)
		
		guard let hashedPassword = password else
		{
			fatalError("Failed to create admin user: username: \(adminName ?? "")     password:\(adminPassword ?? "")")
		}
		
		let user = User(name: "Admin", username: adminName!, password: hashedPassword)
		
		user.superUser = true
		user.adminUser = true
		
		return user.save(on: connection).transform(to: ())
	}
	
	
	static func revert(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return .done(on: connection)
	}
}
