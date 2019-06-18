import Foundation
import Vapor
import FluentPostgreSQL

final class LineOptionCategory: Codable
{
	var id: UUID?
	var name: String
	
	var lineID: Line.ID
	
	var categoryID: PlantCategory.ID
	
	var optionType: Int32?
	
	var changeToken: Int32?
	
	init(name: String, lineID: Line.ID, categoryID: PlantCategory.ID) {
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
			
			builder.reference(from: \.lineID, to: \Line.id)
			
			builder.reference(from: \.categoryID, to: \PlantCategory.id)
		}
	}
	
}

extension LineOptionCategory: Content {}

extension LineOptionCategory: Parameter {}

extension LineOptionCategory
{
	var productLine: Parent<LineOptionCategory, Line> {
		
		return parent(\.lineID)
	}
	
	var builderCategory: Parent<LineOptionCategory, PlantCategory> {
		
		return parent(\.categoryID)
	}
	
	
	var optionItems: Siblings<LineOptionCategory, BuilderOption, LineCategoryOptionPivot> {
		
		return siblings()
	}
	
}


