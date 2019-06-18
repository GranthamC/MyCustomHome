import FluentPostgreSQL
import Foundation


final class HomeSetToHomeModelPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var homeSetID: HomeModelSet.ID
	var homeModelID: HomeModel.ID
	
	typealias Left = HomeModelSet
	typealias Right = HomeModel
	
	static let leftIDKey: LeftIDKey = \.homeSetID
	static let rightIDKey: RightIDKey = \.homeModelID
	
	
	init(_ homeSet: HomeModelSet, _ model: HomeModel) throws {
		
		self.homeSetID = try homeSet.requireID()
		self.homeModelID = try model.requireID()
	}
}


extension HomeSetToHomeModelPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.homeSetID, to: \HomeModelSet.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
}

