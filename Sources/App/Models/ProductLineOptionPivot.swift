import FluentPostgreSQL
import Foundation


final class ProductLineOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var lineID: ProductLine.ID
	var optionItemID: DecorOptionItem.ID
	
	
	typealias Left = ProductLine
	typealias Right = DecorOptionItem
	
	static let leftIDKey: LeftIDKey = \.lineID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ model: ProductLine, _ item: DecorOptionItem) throws {
		
		self.lineID = try model.requireID()
		self.optionItemID = try item.requireID()
	}
}


extension ProductLineOptionPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.optionItemID, to: \DecorOptionItem.id, onDelete: .cascade)
			
			builder.reference(from: \.lineID, to: \ProductLine.id, onDelete: .cascade)
		}
	}
}




