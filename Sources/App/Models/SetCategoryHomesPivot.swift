import FluentPostgreSQL
import Foundation


final class SetCategoryHomesPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var setCategoryID: HomeSetCategory.ID
	var homeModelID: HomeModel.ID
	
	typealias Left = HomeSetCategory
	typealias Right = HomeModel
	
	static let leftIDKey: LeftIDKey = \.setCategoryID
	static let rightIDKey: RightIDKey = \.homeModelID
	
	
	init(_ setCategory: HomeSetCategory, _ model: HomeModel) throws {
		
		self.setCategoryID = try setCategory.requireID()
		self.homeModelID = try model.requireID()
	}
}


extension SetCategoryHomesPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.setCategoryID, to: \HomeSetCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
}


