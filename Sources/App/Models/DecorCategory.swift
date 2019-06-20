import Foundation
import Vapor
import FluentPostgreSQL

final class DecorCategory: Codable
{
	var id: UUID?
	
	var name: String
	
	var plantID: String?
	var plantModelID: Plant.ID
	var plantNumber: String?

	var optionType: Int32?
	
	var categoryID: String?

	var changeToken: Int32?
	
	init(name: String, plantID: Plant.ID) {
		self.name = name
		self.plantModelID = plantID
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

			builder.reference(from: \.plantModelID, to: \Plant.id)
		}
	}
	
}

extension DecorCategory: Content {}

extension DecorCategory: Parameter {}

extension DecorCategory
{
	var builder: Parent<DecorCategory, Plant> {
		
		return parent(\.plantModelID)
	}
	
	
	var categoryOptions: Children<DecorCategory, DecorItem> {
		
		return children(\.categoryModelID)
	}

/*
	var homeModels: Siblings<DecorCategory, HomeModel, HomeModelDecorCategoryPivot> {
		
		return siblings()
	}
	
	var optionItems: Siblings<DecorCategory, DecorItem, DecorCategoryItemPivot> {
		
		return siblings()
	}
*/
}



