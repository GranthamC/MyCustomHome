import Foundation
import Vapor
import FluentPostgreSQL

final class DecorOptionItem: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	var logoURL: String?
	
	init(name: String, builderID: HomeBuilder.ID) {
		self.name = name
		self.builderID = builderID
	}
}

extension DecorOptionItem: PostgreSQLUUIDModel {}

extension DecorOptionItem: Migration
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

extension DecorOptionItem: Content {}

extension DecorOptionItem: Parameter {}

extension DecorOptionItem
{
	var builder: Parent<DecorOptionItem, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var categories: Siblings<DecorOptionItem,
		DecorOptionCategory,
		DecorOptionCategoryPivot> {

		return siblings()
	}
	
	var lines: Siblings<DecorOptionItem,
		ProductLine,
		DecorOptionProductLinePivot> {
		
		return siblings()
	}

}


