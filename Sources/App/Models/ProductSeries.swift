import Foundation
import Vapor
import FluentPostgreSQL

final class ProductSeries: Codable
{
	var id: UUID?
	var name: String
	var lineID: ProductLine.ID
	
	var builderID: HomeBuilder.ID
	
	var changeToken: Int32?
	
	var logoURL: String?
	
	var websiteURL: String?
	var heroImageURL: String?
	
	var features: String?
	var priceBase: Double?
	var priceUpper: Double?
	
	var isEnabled: Bool

	init(name: String, productLine: ProductLine.ID, builderID: HomeBuilder.ID) {
		
		self.name = name
		self.lineID = productLine
		self.builderID = builderID
		self.isEnabled = true
	}
}

extension ProductSeries: PostgreSQLUUIDModel {}

extension ProductSeries: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { line in
			
			try addProperties(to: line)
			
			line.reference(from: \.builderID, to: \HomeBuilder.id)
			
			line.reference(from: \.lineID, to: \ProductLine.id)

			line.unique(on: \.name)
		}
	}
}


extension ProductSeries: Content {}

extension ProductSeries: Parameter {}

extension ProductSeries
{
	var homeModels: Siblings<ProductSeries, HomeModel, ProductSeriesModelPivot> {
		
		return siblings()
	}
	
	var builder: Parent<ProductSeries, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var line: Parent<ProductSeries, ProductLine> {
		
		return parent(\.lineID)
	}
}

