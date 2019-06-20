import FluentPostgreSQL
import Foundation


final class OptionCategoryItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var categoryID: PlantCategory.ID
	var optionItemID: BuilderOption.ID

	
	typealias Left = PlantCategory
	typealias Right = BuilderOption
	
	static let leftIDKey: LeftIDKey = \.categoryID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ category: PlantCategory, _ item: BuilderOption) throws {
		
		self.optionItemID = try item.requireID()
		self.categoryID = try category.requireID()
	}
}


extension OptionCategoryItemPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.categoryID, to: \PlantCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.optionItemID, to: \BuilderOption.id, onDelete: .cascade)
		}
	}
}


