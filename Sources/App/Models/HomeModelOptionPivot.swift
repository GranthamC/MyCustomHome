import FluentPostgreSQL
import Foundation


final class HomeModelOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var homeModelID: HomeModel.ID
	var optionItemID: BuilderOptionItem.ID
	
	
	typealias Left = HomeModel
	typealias Right = BuilderOptionItem
	
	static let leftIDKey: LeftIDKey = \.homeModelID
	static let rightIDKey: RightIDKey = \.optionItemID
	
	
	init(_ model: HomeModel, _ item: BuilderOptionItem) throws {
		
		self.homeModelID = try model.requireID()
		self.optionItemID = try item.requireID()
	}
}


extension HomeModelOptionPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.optionItemID, to: \BuilderOptionItem.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
}


