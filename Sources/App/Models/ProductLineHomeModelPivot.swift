import FluentPostgreSQL
import Foundation


final class ProductLineHomeModelPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?

	var productLineID: Line.ID
	var homeModelID: HomeModel.ID
	

	typealias Left = Line
	typealias Right = HomeModel

	static let leftIDKey: LeftIDKey = \.productLineID
	static let rightIDKey: RightIDKey = \.homeModelID
	

	init(_ line: Line, _ model: HomeModel) throws {
		
		self.productLineID = try line.requireID()
		self.homeModelID = try model.requireID()
	}
}


extension ProductLineHomeModelPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.productLineID, to: \Line.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
}
