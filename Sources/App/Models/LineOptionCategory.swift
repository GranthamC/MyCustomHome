import Foundation
import Vapor
import FluentPostgreSQL

final class LineOptionCategory: Codable
{
	var id: UUID?
	var name: String
	
	var lineID: ProductLine.ID
	
	var categoryID: BuilderCategory.ID
	
	var optionType: Int32?
	
	var changeToken: Int32?
	
	init(name: String, lineID: ProductLine.ID, categoryID: BuilderCategory.ID) {
		self.name = name
		self.lineID = lineID
		self.categoryID = categoryID
	}
}

extension LineOptionCategory: PostgreSQLUUIDModel {}

extension LineOptionCategory: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			//			builder.unique(on: \.name)
			
			builder.reference(from: \.lineID, to: \ProductLine.id)
			
			builder.reference(from: \.categoryID, to: \BuilderCategory.id)
		}
	}
	
}

extension LineOptionCategory: Content {}

extension LineOptionCategory: Parameter {}

extension LineOptionCategory
{
	var productLine: Parent<LineOptionCategory, ProductLine> {
		
		return parent(\.lineID)
	}
	
	var builderCategory: Parent<LineOptionCategory, BuilderCategory> {
		
		return parent(\.categoryID)
	}
	
	
	var optionItems: Siblings<LineOptionCategory, BuilderOption, LineCategoryOptionPivot> {
		
		return siblings()
	}
	
}


