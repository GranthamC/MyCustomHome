import FluentPostgreSQL
import Foundation


final class HomeModelDecorItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var homeModelID: HomeModel.ID
	var optionItemID: DecorOptionItem.ID
	
	
	typealias Left = HomeModel
	typealias Right = DecorOptionItem
	
	static let leftIDKey: LeftIDKey = \.homeModelID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ model: HomeModel, _ item: DecorOptionItem) throws {
		
		self.homeModelID = try model.requireID()
		self.optionItemID = try item.requireID()
	}
}


extension HomeModelDecorItemPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.optionItemID, to: \DecorOptionItem.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
}



