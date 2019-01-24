import Foundation
import Vapor
import FluentPostgreSQL

final class HomeModel: Codable
{
	var id: UUID?
	var name: String
	var modelNumber: String
	var productLineID: ProductLine.ID
	
	var heroImageURL: String?
	var matterportTourURL: String?
	var panoModelTourURL: String?
	
	var sqft: Int16?
	var baths: Float?
	var beds: Int16?
	var features: String?
	var priceBase: Double?
	var priceUpper: Double?
	
	var isEnabled: Bool
	var isSingleSection: Bool
	
	var hasBasement: Bool?
	var sqftBasement: Int16?
	var sqftMain: Int16?
	var sqftUpper: Int16?
	
	
	init(name: String, modelNumber: String, productLineID: ProductLine.ID) {
		self.name = name
		self.modelNumber = modelNumber
		self.productLineID = productLineID
		
		self.isEnabled = true
		self.isSingleSection = false
	}
}

extension HomeModel: PostgreSQLUUIDModel {}

extension HomeModel: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.productLineID, to: \HomeBuilder.id)
		}
	}
	
}

extension HomeModel: Content {}

extension HomeModel: Parameter {}

extension HomeModel
{
	var productLine: Parent<HomeModel, ProductLine> {
		
		return parent(\.productLineID)
	}
	
	var homeOptions: Siblings<HomeModel, HomeOptionItem, HomeOptionHomeModelPivot> {
		
		return siblings()
	}

}

