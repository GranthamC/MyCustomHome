import Foundation
import Vapor
import FluentPostgreSQL

final class DecorPackage: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	
	init(name: String, builderID: HomeBuilder.ID) {
		self.name = name
		self.builderID = builderID
	}
}

extension DecorPackage: PostgreSQLUUIDModel {}

extension DecorPackage: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.builderID, to: \HomeBuilder.id)
		}
	}
	
}

extension DecorPackage: Content {}

extension DecorPackage: Parameter {}

extension DecorPackage
{
	var builder: Parent<DecorPackage, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var optionItems: Siblings<DecorPackage, HomeOptionItem, DecorPackageOptionPivot> {
		
		return siblings()
	}
	
}



