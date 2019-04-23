import FluentPostgreSQL
import Foundation


final class ProductSeriesModelPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var productSeriesID: ProductSeries.ID
	var homeModelID: HomeModel.ID
	
	
	typealias Left = ProductSeries
	typealias Right = HomeModel
	
	static let leftIDKey: LeftIDKey = \.productSeriesID
	static let rightIDKey: RightIDKey = \.homeModelID
	
	
	init(_ line: ProductSeries, _ model: HomeModel) throws {
		
		self.productSeriesID = try line.requireID()
		self.homeModelID = try model.requireID()
	}
}


extension ProductSeriesModelPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.productSeriesID, to: \ProductSeries.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
}


