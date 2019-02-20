import Foundation
import Vapor
import FluentPostgreSQL

final class OptionCategory: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	
	var changeToken: Int32?

	var optionType: Int32?

	init(name: String, builderID: HomeBuilder.ID) {
		self.name = name
		self.builderID = builderID
	}
}

extension OptionCategory: PostgreSQLUUIDModel {}

extension OptionCategory: Migration
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

extension OptionCategory: Content {}

extension OptionCategory: Parameter {}

extension OptionCategory
{
	var builder: Parent<OptionCategory, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var categoryOptions: Children<OptionCategory, OptionItem> {
		
		return children(\.categoryID)
	}

	var homeModels: Siblings<OptionCategory, HomeModel, HomeModelCategoryPivot> {
		
		return siblings()
	}
	
	var optionItems: Siblings<OptionCategory, OptionItem, OptionCategoryItemPivot> {
		
		return siblings()
	}

}


