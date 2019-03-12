import Foundation
import Vapor
import FluentPostgreSQL

final class DecorCategory: Codable
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

extension DecorCategory: PostgreSQLUUIDModel {}

extension DecorCategory: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.unique(on: \.name)

			builder.reference(from: \.builderID, to: \HomeBuilder.id)
		}
	}
	
}

extension DecorCategory: Content {}

extension DecorCategory: Parameter {}

extension DecorCategory
{
	var builder: Parent<DecorCategory, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	
	var categoryOptions: Children<DecorCategory, DecorItem> {
		
		return children(\.categoryID)
	}

	
	var homeModels: Siblings<DecorCategory, HomeModel, HomeModelDecorCategoryPivot> {
		
		return siblings()
	}
	
	var optionItems: Siblings<DecorCategory, DecorItem, DecorCategoryItemPivot> {
		
		return siblings()
	}
	
}



