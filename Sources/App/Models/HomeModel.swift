import Foundation
import Vapor
import FluentPostgreSQL

final class HomeModel: Codable
{
	var id: UUID?
	var name: String
	var modelNumber: String
	var builderID: HomeBuilder.ID
	
	var changeToken: Int32?

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
	
	
	init(name: String, modelNumber: String, builderID: HomeBuilder.ID) {
		self.name = name
		self.modelNumber = modelNumber
		self.builderID = builderID
		
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

			homeModel.reference(from: \.builderID, to: \HomeBuilder.id)
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
	
	var decorCategories: Siblings<HomeModel, DecorCategory, HomeModelDecorCategoryPivot> {
		
		return siblings()
	}
	
	var decorItems: Siblings<HomeModel, DecorItem, HomeModelDecorItemPivot> {
		
		return siblings()
	}
	
	var optionCategories: Siblings<HomeModel, OptionCategory, HomeModelCategoryPivot> {
		
		return siblings()
	}
	
	var optionItems: Siblings<HomeModel, OptionItem, HomeModelOptionPivot> {
		
		return siblings()
	}
	
	var productLines: Siblings<HomeModel, ProductLine, ProductLineHomeModelPivot> {
		
		return siblings()
	}
	
	var images: Siblings<HomeModel, ImageAsset, ImageAssetHomeModelPivot> {
		
		return siblings()
	}

	var builder: Parent<HomeModel, HomeBuilder> {
		
		return parent(\.builderID)
	}

}

