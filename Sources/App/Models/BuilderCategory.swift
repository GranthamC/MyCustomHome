import Foundation
import Vapor
import FluentPostgreSQL

final class BuilderCategory: Codable
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

extension BuilderCategory: PostgreSQLUUIDModel {}

extension BuilderCategory: Migration
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

extension BuilderCategory: Content {}

extension BuilderCategory: Parameter {}

extension BuilderCategory
{
	var builder: Parent<BuilderCategory, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var categoryOptions: Children<BuilderCategory, BuilderOption> {
		
		return children(\.categoryID)
	}

	var homeModels: Siblings<BuilderCategory, HomeModel, HomeModelCategoryPivot> {
		
		return siblings()
	}
	
	var optionItems: Siblings<BuilderCategory, BuilderOption, OptionCategoryItemPivot> {
		
		return siblings()
	}

}


