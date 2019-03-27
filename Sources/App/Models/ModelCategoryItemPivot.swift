import FluentPostgreSQL
import Foundation


final class ModelCategoryItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var categoryID: ModelDecorCategory.ID
	var decorItemID: DecorItem.ID
	
	
	typealias Left = ModelDecorCategory
	typealias Right = DecorItem
	
	static let leftIDKey: LeftIDKey = \.categoryID
	static let rightIDKey: RightIDKey = \.decorItemID
	
	
	init(_ category: ModelDecorCategory, _ option: DecorItem) throws {
		self.categoryID = try category.requireID()
		self.decorItemID = try option.requireID()
	}
}


extension ModelCategoryItemPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.categoryID, to: \ModelDecorCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.decorItemID, to: \DecorItem.id, onDelete: .cascade)
		}
	}
	
}






