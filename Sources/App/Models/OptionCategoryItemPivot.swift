import FluentPostgreSQL
import Foundation


final class OptionCategoryItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var categoryID: OptionCategory.ID
	var optionItemID: OptionItem.ID

	
	typealias Left = OptionCategory
	typealias Right = OptionItem
	
	static let leftIDKey: LeftIDKey = \.categoryID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ category: OptionCategory, _ item: OptionItem) throws {
		
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
			
			builder.reference(from: \.categoryID, to: \OptionCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.optionItemID, to: \OptionItem.id, onDelete: .cascade)
		}
	}
}


