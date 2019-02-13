import FluentPostgreSQL
import Foundation


final class ProductLineCategoryPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var lineID: ProductLine.ID
	var categoryID: DecorCategory.ID
	
	
	typealias Left = ProductLine
	typealias Right = DecorCategory
	
	static let leftIDKey: LeftIDKey = \.lineID
	static let rightIDKey: RightIDKey = \.categoryID
	
	
	init(_ model: ProductLine, _ category: DecorCategory) throws {
		
		self.lineID = try model.requireID()
		self.categoryID = try category.requireID()
	}
}


extension ProductLineCategoryPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.categoryID, to: \DecorCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.lineID, to: \ProductLine.id, onDelete: .cascade)
		}
	}
}



