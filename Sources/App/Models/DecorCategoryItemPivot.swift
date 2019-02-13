import FluentPostgreSQL
import Foundation


final class DecorCategoryItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var categoryID: DecorCategory.ID
	var optionItemID: DecorItem.ID
	
	
	typealias Left = DecorCategory
	typealias Right = DecorItem
	
	static let leftIDKey: LeftIDKey = \.categoryID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ category: DecorCategory, _ item: DecorItem) throws {
		
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
			
			builder.reference(from: \.categoryID, to: \DecorCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.optionItemID, to: \DecorItem.id, onDelete: .cascade)
		}
	}
}



