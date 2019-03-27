import FluentPostgreSQL
import Foundation


final class LineCategoryItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var categoryID: LineDecorCategory.ID
	var decorItemID: DecorItem.ID
	
	
	typealias Left = LineDecorCategory
	typealias Right = DecorItem
	
	static let leftIDKey: LeftIDKey = \.categoryID
	static let rightIDKey: RightIDKey = \.decorItemID
	
	
	init(_ category: LineDecorCategory, _ option: DecorItem) throws {
		self.categoryID = try category.requireID()
		self.decorItemID = try option.requireID()
	}
}


extension LineCategoryItemPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.categoryID, to: \LineDecorCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.decorItemID, to: \DecorItem.id, onDelete: .cascade)
		}
	}
	
}





