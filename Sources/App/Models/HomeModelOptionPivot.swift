import FluentPostgreSQL
import Foundation


final class HomeModelOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var homeModelID: HomeModel.ID
	var optionItemID: HomeOptionItem.ID
	
	
	typealias Left = HomeModel
	typealias Right = HomeOptionItem
	
	static let leftIDKey: LeftIDKey = \.homeModelID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ model: HomeModel, _ category: HomeOptionItem) throws {
		
		self.homeModelID = try model.requireID()
		self.optionItemID = try category.requireID()
	}
}


extension HomeModelOptionPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.optionItemID, to: \HomeOptionItem.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
}


