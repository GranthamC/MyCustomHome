import Foundation
import Vapor
import FluentPostgreSQL

final class ProductSeries: Codable
{
	var id: UUID?
	var name: String
	var lineID: Line.ID
	
	var plantID: Plant.ID
	
	var changeToken: Int32?
	
	var logoURL: String?
	
	var websiteURL: String?
	var heroImageURL: String?
	
	var features: String?
	var priceBase: Double?
	var priceUpper: Double?
	
	var isEnabled: Bool

	init(name: String, productLine: Line.ID, plantID: Plant.ID) {
		
		self.name = name
		self.lineID = productLine
		self.plantID = plantID
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
			
			line.reference(from: \.plantID, to: \Plant.id)
			
			line.reference(from: \.lineID, to: \Line.id)

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
	
	var builder: Parent<ProductSeries, Plant> {
		
		return parent(\.plantID)
	}
	
	var line: Parent<ProductSeries, Line> {
		
		return parent(\.lineID)
	}
}

