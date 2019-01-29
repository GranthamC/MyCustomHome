import Foundation
import Vapor
import FluentPostgreSQL

final class LineDecorCategory: Codable
{
	var id: UUID?
	var lineID: ProductLine.ID
	var categoryID: DecorOptionCategory.ID
	
	init(categoryID: DecorOptionCategory.ID, lineID: ProductLine.ID) {
		self.categoryID = categoryID
		self.lineID = lineID
	}
}

extension LineDecorCategory: PostgreSQLUUIDModel {}

extension LineDecorCategory: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { category in
			
			try addProperties(to: category)
			
			category.reference(from: \.lineID, to: \ProductLine.id)
			
			category.reference(from: \.categoryID, to: \DecorOptionCategory.id)
		}
	}
	
}

extension LineDecorCategory: Content {}

extension LineDecorCategory: Parameter {}

extension LineDecorCategory
{
	var productLine: Parent<LineDecorCategory, ProductLine> {
		
		return parent(\.lineID)
	}
	
	var decorOptions: Children<LineDecorCategory, LineDecorOptionItem> {
		
		return children(\.categoryID)
	}

}

