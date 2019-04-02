import FluentPostgreSQL
import Foundation


final class ModelCategoryItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var catID: HM_DecorCategory.ID
	var itemID: DecorItem.ID
	
	
	typealias Left = HM_DecorCategory
	typealias Right = DecorItem
	
	static let leftIDKey: LeftIDKey = \.catID
	static let rightIDKey: RightIDKey = \.itemID
	
	
	init(_ category: HM_DecorCategory, _ option: DecorItem) throws {
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
			
			builder.reference(from: \.catID, to: \HM_DecorCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.itemID, to: \DecorItem.id, onDelete: .cascade)
		}
	}
	
}






