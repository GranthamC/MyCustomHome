import FluentPostgreSQL
import Foundation


final class DecorPackageOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var decorPackageID: DecorPackage.ID
	var optionItemID: DecorItem.ID
	
	
	typealias Left = DecorPackage
	typealias Right = DecorItem
	
	static let leftIDKey: LeftIDKey = \.decorPackageID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ category: DecorPackage, _ item: DecorItem) throws {
		
		self.optionItemID = try item.requireID()
		self.decorPackageID = try category.requireID()
	}
}


extension DecorPackageOptionPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.decorPackageID, to: \DecorPackage.id, onDelete: .cascade)
			
			builder.reference(from: \.optionItemID, to: \DecorItem.id, onDelete: .cascade)
		}
	}
}



