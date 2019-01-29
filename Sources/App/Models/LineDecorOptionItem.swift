import Foundation
import Vapor
import FluentPostgreSQL

final class LineDecorOptionItem: Codable
{
	var id: UUID?
	var itemID: DecorOptionItem.ID
	var categoryID: LineDecorCategory.ID
	
	var name: String
	
	init(name: String, categoryID: LineDecorCategory.ID, itemID: DecorOptionItem.ID) {
		
		self.name = name
		self.categoryID = categoryID
		self.itemID = itemID
	}
}

extension LineDecorOptionItem: PostgreSQLUUIDModel {}

extension LineDecorOptionItem: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { optionItem in
			
			try addProperties(to: optionItem)
			
			optionItem.reference(from: \.itemID, to: \DecorOptionItem.id)
			
			optionItem.reference(from: \.categoryID, to: \LineDecorCategory.id)
		}
	}
	
}

extension LineDecorOptionItem: Content {}

extension LineDecorOptionItem: Parameter {}

extension LineDecorOptionItem
{
	var lineCategory: Parent<LineDecorOptionItem, LineDecorCategory> {
		
		return parent(\.categoryID)
	}
	
	var decorOption: Parent<LineDecorOptionItem, DecorOptionItem> {
		
		return parent(\.itemID)
	}
	
}


