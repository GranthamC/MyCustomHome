import FluentPostgreSQL
import Foundation


final class ProductLineOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var lineID: ProductLine.ID
	var optionItemID: HomeOptionItem.ID
	
	
	typealias Left = ProductLine
	typealias Right = HomeOptionItem
	
	static let leftIDKey: LeftIDKey = \.lineID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ model: ProductLine, _ category: HomeOptionItem) throws {
		
		self.lineID = try model.requireID()
		self.optionItemID = try category.requireID()
	}
}


extension ProductLineOptionPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.optionItemID, to: \HomeOptionItem.id, onDelete: .cascade)
			
			builder.reference(from: \.lineID, to: \ProductLine.id, onDelete: .cascade)
		}
	}
}



