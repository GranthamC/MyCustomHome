import FluentPostgreSQL
import Foundation


final class OptionCategoryItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var categoryID: HomeOptionCategory.ID
	var optionItemID: HomeOptionItem.ID

	
	typealias Left = HomeOptionCategory
	typealias Right = HomeOptionItem
	
	static let leftIDKey: LeftIDKey = \.categoryID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ category: HomeOptionCategory, _ item: HomeOptionItem) throws {
		
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
			
			builder.reference(from: \.categoryID, to: \HomeOptionCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.optionItemID, to: \HomeOptionItem.id, onDelete: .cascade)
		}
	}
}


