import Foundation
import Vapor
import FluentPostgreSQL

final class LineDecorCategory: Codable
{
	var id: UUID?
	var name: String
	
	var lineID: ProductLine.ID
	
	var optionType: Int32?
	
	var changeToken: Int32?
	
	init(name: String, lineID: ProductLine.ID) {
		self.name = name
		self.lineID = lineID
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
			
			builder.reference(from: \.lineID, to: \ProductLine.id)
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
	
	
	var optionItems: Siblings<LineDecorCategory, DecorItem, LineCategoryItemPivot> {
		
		return siblings()
	}
	
}




