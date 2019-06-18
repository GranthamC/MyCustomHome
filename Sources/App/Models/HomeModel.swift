import Foundation
import Vapor
import FluentPostgreSQL

final class HomeModel: Codable
{
	var id: UUID?
	var name: String
	var modelNumber: String
	var plantModelID: Plant.ID
	var lineModelID: Line.ID
	
	var changeToken: Int32?

	var heroImageURL: String?
	var floorPlanURL: String?
	var exteriorImageURL: String?
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

	var modelID: String?
	var modelDescription: String?
	
	var lineID: String?
	var plantID: String?

	init(name: String, modelNumber: String, plantModelID: Plant.ID, lineModelID: Line.ID) {
		self.name = name
		self.modelNumber = modelNumber
		self.plantModelID = plantModelID
		self.lineModelID = lineModelID
		
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
		
		return Database.create(self, on: connection) { homeModel in
			
			try addProperties(to: homeModel)

			homeModel.reference(from: \.plantModelID, to: \Plant.id)
			
			homeModel.reference(from: \.lineModelID, to: \Line.id)
			
			homeModel.unique(on: \.modelNumber)
		}
	}
	
}

extension HomeModel: Content {}

extension HomeModel: Parameter {}

extension HomeModel
{
	
	var modelOptions: Children<HomeModel, ModelOption> {
		
		return children(\.modelID)
	}
	
	var decorCategories: Children<HomeModel, HM_DecorCategory> {
		
		return children(\.modelID)
	}
	
	var builderOptionCategories: Children<HomeModel, HM_BdrOptCategory> {
		
		return children(\.modelID)
	}

	var productLines: Siblings<HomeModel, Line, ProductLineHomeModelPivot> {
		
		return siblings()
	}

	var productLine: Parent<HomeModel, Line> {
		
		return parent(\.lineModelID)
	}

	var images: Siblings<HomeModel, Image, ImageAssetHomeModelPivot> {
		
		return siblings()
	}

	var builder: Parent<HomeModel, Plant> {
		
		return parent(\.plantModelID)
	}

}

