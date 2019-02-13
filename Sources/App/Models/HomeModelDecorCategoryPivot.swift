import FluentPostgreSQL
import Foundation


final class HomeModelDecorCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var homeModelID: HomeModel.ID
	var categoryID: DecorCategory.ID
	
	
	typealias Left = HomeModel
	typealias Right = DecorCategory
	
	static let leftIDKey: LeftIDKey = \.homeModelID
	static let rightIDKey: RightIDKey = \.categoryID
	
	
	init(_ model: HomeModel, _ category: DecorCategory) throws {
		
		self.homeModelID = try model.requireID()
		self.categoryID = try category.requireID()
	}
}


extension HomeModelDecorCategoryPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.categoryID, to: \DecorCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
}


