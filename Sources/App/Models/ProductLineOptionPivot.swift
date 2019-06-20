import FluentPostgreSQL
import Foundation


final class ProductLineOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var lineID: Line.ID
	var optionItemID: DecorItem.ID
	
	
	typealias Left = Line
	typealias Right = DecorItem
	
	static let leftIDKey: LeftIDKey = \.lineID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ model: Line, _ item: DecorItem) throws {
		
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
			
			builder.reference(from: \.optionItemID, to: \DecorItem.id, onDelete: .cascade)
			
			builder.reference(from: \.lineID, to: \Line.id, onDelete: .cascade)
		}
	}
}




