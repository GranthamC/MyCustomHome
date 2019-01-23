import FluentPostgreSQL
import Foundation


final class HomeOptionCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	
	var id: UUID?
	
	var homeOptionID: HomeOptionItem.ID
	var categoryID: HomeOptionCategory.ID
	
	
	typealias Left = HomeOptionItem
	typealias Right = HomeOptionCategory
	
	static let leftIDKey: LeftIDKey = \.homeOptionID
	static let rightIDKey: RightIDKey = \.categoryID
	
	
	init(_ option: HomeOptionItem, _ category: HomeOptionCategory) throws {
		self.homeOptionID = try option.requireID()
		self.categoryID = try category.requireID()
	}
}


extension HomeOptionCategoryPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.homeOptionID, to: \HomeOptionItem.id, onDelete: .cascade)
			
			builder.reference(from: \.categoryID, to: \HomeOptionCategory.id, onDelete: .cascade)
		}
	}
	
}


