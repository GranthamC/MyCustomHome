import FluentPostgreSQL
import Foundation


final class DecorOptionCategoryPivot: PostgreSQLUUIDPivot,
ModifiablePivot {

	var id: UUID?

	var decorOptionID: DecorOptionItem.ID
	var categoryID: DecorOptionCategory.ID
	

	typealias Left = DecorOptionItem
	typealias Right = DecorOptionCategory

	static let leftIDKey: LeftIDKey = \.decorOptionID
	static let rightIDKey: RightIDKey = \.categoryID
	

	init(_ option: DecorOptionItem, _ category: DecorOptionCategory) throws {
		self.decorOptionID = try option.requireID()
		self.categoryID = try category.requireID()
	}
}


extension DecorOptionCategoryPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in

			try addProperties(to: builder)

			builder.reference(from: \.decorOptionID, to: \DecorOptionItem.id, onDelete: .cascade)

			builder.reference(from: \.categoryID, to: \DecorOptionCategory.id, onDelete: .cascade)
		}
	}
	
}

