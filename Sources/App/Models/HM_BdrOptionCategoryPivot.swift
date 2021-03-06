import FluentPostgreSQL
import Foundation


final class HM_BdrOptionCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var catID: HM_BdrOptCategory.ID
	var optionID: BuilderOption.ID
	
	
	typealias Left = HM_BdrOptCategory
	typealias Right = BuilderOption
	
	static let leftIDKey: LeftIDKey = \.catID
	static let rightIDKey: RightIDKey = \.optionID
	
	
	init(_ category: HM_BdrOptCategory, _ item: BuilderOption) throws {
		
		self.optionID = try item.requireID()
		self.catID = try category.requireID()
	}
}


extension HM_BdrOptionCategoryPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.catID, to: \HM_BdrOptCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.optionID, to: \BuilderOption.id, onDelete: .cascade)
		}
	}
}




