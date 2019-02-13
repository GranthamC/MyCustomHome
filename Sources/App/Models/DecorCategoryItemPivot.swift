import FluentPostgreSQL
import Foundation


final class DecorCategoryItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var categoryID: DecorOptionCategory.ID
	var optionItemID: DecorOptionItem.ID
	
	
	typealias Left = DecorOptionCategory
	typealias Right = DecorOptionItem
	
	static let leftIDKey: LeftIDKey = \.categoryID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ category: DecorOptionCategory, _ item: DecorOptionItem) throws {
		
		self.optionItemID = try item.requireID()
		self.categoryID = try category.requireID()
	}
}


extension DecorCategoryItemPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.categoryID, to: \DecorOptionCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.optionItemID, to: \DecorOptionItem.id, onDelete: .cascade)
		}
	}
}



