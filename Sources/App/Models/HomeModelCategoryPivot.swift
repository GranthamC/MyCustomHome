import FluentPostgreSQL
import Foundation


final class HomeModelCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var homeModelID: HomeModel.ID
	var categoryID: BuilderCategory.ID

	
	typealias Left = HomeModel
	typealias Right = BuilderCategory
	
	static let leftIDKey: LeftIDKey = \.homeModelID
	static let rightIDKey: RightIDKey = \.categoryID
	
	
	init(_ model: HomeModel, _ category: BuilderCategory) throws {
		
		self.homeModelID = try model.requireID()
		self.categoryID = try category.requireID()
	}
}


extension HomeModelCategoryPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.categoryID, to: \BuilderCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
}

