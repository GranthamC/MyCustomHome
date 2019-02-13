import Foundation
import Vapor
import FluentPostgreSQL

final class DecorOptionCategory: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	
	var optionType: Int32?
	
	var changeToken: Int32?
	
	init(name: String, builderID: HomeBuilder.ID) {
		self.name = name
		self.builderID = builderID
	}
}

extension DecorOptionCategory: PostgreSQLUUIDModel {}

extension DecorOptionCategory: Migration
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

extension DecorOptionCategory: Content {}

extension DecorOptionCategory: Parameter {}

extension DecorOptionCategory
{
	var builder: Parent<DecorOptionCategory, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var homeModels: Siblings<DecorOptionCategory, HomeModel, HomeModelDecorCategoryPivot> {
		
		return siblings()
	}
	
	var optionItems: Siblings<DecorOptionCategory, DecorOptionItem, DecorCategoryItemPivot> {
		
		return siblings()
	}
	
}



