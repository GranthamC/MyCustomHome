import Foundation
import Vapor
import FluentPostgreSQL

final class HomeModelOptionItem: Codable
{
	var id: UUID?
	var itemID: HomeOptionItem.ID
	var categoryID: HomeModelOptionCategory.ID
	
	var name: String
	
	init(name: String, categoryID: HomeModelOptionCategory.ID, itemID: HomeOptionItem.ID) {
		
		self.name = name
		self.categoryID = categoryID
		self.itemID = itemID
	}
}

extension HomeModelOptionItem: PostgreSQLUUIDModel {}

extension HomeModelOptionItem: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { optionItem in
			
			try addProperties(to: optionItem)
			
			optionItem.reference(from: \.itemID, to: \HomeOptionItem.id)
			
			optionItem.reference(from: \.categoryID, to: \HomeModelOptionCategory.id)
		}
	}
	
}

extension HomeModelOptionItem: Content {}

extension HomeModelOptionItem: Parameter {}

extension HomeModelOptionItem
{
	var modelCategory: Parent<HomeModelOptionItem, HomeModelOptionCategory> {
		
		return parent(\.categoryID)
	}
	
	var homeOption: Parent<HomeModelOptionItem, HomeOptionItem> {
		
		return parent(\.itemID)
	}
	
}



