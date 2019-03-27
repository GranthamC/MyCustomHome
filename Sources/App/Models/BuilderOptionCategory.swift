import Foundation
import Vapor
import FluentPostgreSQL

final class BuilderOptionCategory: Codable
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

extension BuilderOptionCategory: PostgreSQLUUIDModel {}

extension BuilderOptionCategory: Migration
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

extension BuilderOptionCategory: Content {}

extension BuilderOptionCategory: Parameter {}

extension BuilderOptionCategory
{
	var builder: Parent<BuilderOptionCategory, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var categoryOptions: Children<BuilderOptionCategory, BuilderOptionItem> {
		
		return children(\.categoryID)
	}

	var homeModels: Siblings<BuilderOptionCategory, HomeModel, HomeModelCategoryPivot> {
		
		return siblings()
	}
	
	var optionItems: Siblings<BuilderOptionCategory, BuilderOptionItem, OptionCategoryItemPivot> {
		
		return siblings()
	}

}


