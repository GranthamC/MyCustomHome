import FluentPostgreSQL
import Foundation


final class DecorOptionProductLinePivot: PostgreSQLUUIDPivot,
ModifiablePivot {
	
	var id: UUID?
	
	var decorOptionID: DecorOptionItem.ID
	var productLineID: ProductLine.ID
	
	
	typealias Left = DecorOptionItem
	typealias Right = ProductLine
	
	static let leftIDKey: LeftIDKey = \.decorOptionID
	static let rightIDKey: RightIDKey = \.productLineID
	
	
	init(_ option: DecorOptionItem, _ line: ProductLine) throws {
		self.decorOptionID = try option.requireID()
		self.productLineID = try line.requireID()
	}
}


extension DecorOptionProductLinePivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.decorOptionID, to: \DecorOptionItem.id, onDelete: .cascade)
			
			builder.reference(from: \.productLineID, to: \ProductLine.id, onDelete: .cascade)
		}
	}
	
}


