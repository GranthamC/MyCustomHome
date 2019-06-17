import Foundation
import Vapor
import FluentPostgreSQL

final class PlantCategory: Codable
{
	var id: UUID?
	var name: String
	var builderID: Plant.ID

	var changeToken: Int32?

	var optionType: Int32?

	init(name: String, builderID: Plant.ID) {
		self.name = name
		self.builderID = builderID
	}
}

extension PlantCategory: PostgreSQLUUIDModel {}

extension PlantCategory: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.unique(on: \.name)

			builder.reference(from: \.builderID, to: \Plant.id)
		}
	}
	
}

extension PlantCategory: Content {}

extension PlantCategory: Parameter {}

extension PlantCategory
{
	var builder: Parent<PlantCategory, Plant> {
		
		return parent(\.builderID)
	}
	
	var categoryOptions: Children<PlantCategory, BuilderOption> {
		
		return children(\.categoryID)
	}

	var homeModels: Siblings<PlantCategory, HomeModel, HomeModelCategoryPivot> {
		
		return siblings()
	}
	
	var optionItems: Siblings<PlantCategory, BuilderOption, OptionCategoryItemPivot> {
		
		return siblings()
	}

}


