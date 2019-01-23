import FluentPostgreSQL
import Foundation


final class HomeOptionHomeModelPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	
	var id: UUID?
	
	var homeOptionID: HomeOptionItem.ID
	var homeModelID: HomeModel.ID
	
	
	typealias Left = HomeOptionItem
	typealias Right = HomeModel
	
	static let leftIDKey: LeftIDKey = \.homeOptionID
	static let rightIDKey: RightIDKey = \.homeModelID
	
	
	init(_ option: HomeOptionItem, _ model: HomeModel) throws {
		self.homeOptionID = try option.requireID()
		self.homeModelID = try model.requireID()
	}
}


extension HomeOptionHomeModelPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.homeOptionID, to: \HomeOptionItem.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
	
}



