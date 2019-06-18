import FluentPostgreSQL
import Foundation


final class ProductLineDecorPackagePivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var lineID: Line.ID
	var packageID: DecorPackage.ID
	
	
	typealias Left = Line
	typealias Right = DecorPackage
	
	static let leftIDKey: LeftIDKey = \.lineID
	static let rightIDKey: RightIDKey = \.packageID
	
	
	init(_ model: Line, _ category: DecorPackage) throws {
		
		self.lineID = try model.requireID()
		self.packageID = try category.requireID()
	}
}


extension ProductLineDecorPackagePivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.packageID, to: \DecorPackage.id, onDelete: .cascade)
			
			builder.reference(from: \.lineID, to: \Line.id, onDelete: .cascade)
		}
	}
}




