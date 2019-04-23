import FluentPostgreSQL
import Foundation


final class LineCategoryOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var catID: LineOptionCategory.ID
	var optionID: BuilderOption.ID
	
	
	typealias Left = LineOptionCategory
	typealias Right = BuilderOption
	
	static let leftIDKey: LeftIDKey = \.catID
	static let rightIDKey: RightIDKey = \.optionID
	
	
	init(_ category: LineOptionCategory, _ option: BuilderOption) throws {
		self.catID = try category.requireID()
		self.optionID = try option.requireID()
	}
}


extension LineCategoryOptionPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.catID, to: \LineOptionCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.optionID, to: \BuilderOption.id, onDelete: .cascade)
		}
	}
	
}


