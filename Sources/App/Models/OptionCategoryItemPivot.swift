import FluentPostgreSQL
import Foundation


final class OptionCategoryItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var categoryID: BuilderOptionCategory.ID
	var optionItemID: BuilderOptionItem.ID

	
	typealias Left = BuilderOptionCategory
	typealias Right = BuilderOptionItem
	
	static let leftIDKey: LeftIDKey = \.categoryID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ category: BuilderOptionCategory, _ item: BuilderOptionItem) throws {
		
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
			
			builder.reference(from: \.categoryID, to: \BuilderOptionCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.optionItemID, to: \BuilderOptionItem.id, onDelete: .cascade)
		}
	}
}


