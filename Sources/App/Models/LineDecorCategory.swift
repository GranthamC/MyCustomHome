import Foundation
import Vapor
import FluentPostgreSQL

final class LineDecorCategory: Codable
{
	var id: UUID?
	var name: String
	
	var lineID: Line.ID
	
	var categoryID: DecorCategory.ID

	var optionType: Int32?
	
	var changeToken: Int32?
	
	init(name: String, lineID: Line.ID, categoryID: DecorCategory.ID) {
		self.name = name
		self.lineID = lineID
		self.categoryID = categoryID
	}
}

extension LineDecorCategory: PostgreSQLUUIDModel {}

extension LineDecorCategory: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
//			builder.unique(on: \.name)
			
			builder.reference(from: \.lineID, to: \Line.id)
			
			builder.reference(from: \.categoryID, to: \DecorCategory.id)
		}
	}
	
}

extension LineDecorCategory: Content {}

extension LineDecorCategory: Parameter {}

extension LineDecorCategory
{
	var productLine: Parent<LineDecorCategory, Line> {
		
		return parent(\.lineID)
	}
	
	var decorCategory: Parent<LineDecorCategory, DecorCategory> {
		
		return parent(\.categoryID)
	}
	

	var optionItems: Siblings<LineDecorCategory, DecorItem, LineCategoryItemPivot> {
		
		return siblings()
	}
	
}




