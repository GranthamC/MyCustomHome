import FluentPostgreSQL
import Foundation


final class ModelCategoryItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var catID: ModelDecorCategory.ID
	var itemID: DecorItem.ID
	
	
	typealias Left = ModelDecorCategory
	typealias Right = DecorItem
	
	static let leftIDKey: LeftIDKey = \.catID
	static let rightIDKey: RightIDKey = \.itemID
	
	
	init(_ category: ModelDecorCategory, _ option: DecorItem) throws {
		self.catID = try category.requireID()
		self.itemID = try option.requireID()
	}
}


extension ModelCategoryItemPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.catID, to: \ModelDecorCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.itemID, to: \DecorItem.id, onDelete: .cascade)
		}
	}
	
}






