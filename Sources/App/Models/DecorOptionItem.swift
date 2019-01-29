import Foundation
import Vapor
import FluentPostgreSQL

final class DecorOptionItem: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	var categoryID: DecorOptionCategory.ID
	
	var optionImageURL: String?
	
	var optionModelURL: String?
	
	var decorOptionColor: UInt32?
	var imageScale: Float?
	var isUpgrade: Bool?
	var optionType: Int64?
	var physicalHeight: Float?
	var physicalWidth: Float?
	
	init(name: String, builderID: HomeBuilder.ID, categoryID: DecorOptionCategory.ID) {
		self.name = name
		self.builderID = builderID
		self.categoryID = categoryID
	}
}

extension DecorOptionItem: PostgreSQLUUIDModel {}

extension DecorOptionItem: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { optionItem in
			
			try addProperties(to: optionItem)
			
			optionItem.reference(from: \.builderID, to: \HomeBuilder.id)
			
			optionItem.reference(from: \.categoryID, to: \DecorOptionCategory.id)
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
	
	var category: Parent<DecorOptionItem, DecorOptionCategory> {
		
		return parent(\.categoryID)
	}
	
}


