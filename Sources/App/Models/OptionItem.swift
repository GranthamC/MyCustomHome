import Foundation
import Vapor
import FluentPostgreSQL

final class OptionItem: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	
	var categoryID: OptionCategory.ID

	var changeToken: Int32?

	var optionImageURL: String
	
	var optionModelURL: String?
	
	var detailInfo: String?
	
	var optionColor: Int32?
	var imageScale: Float?
	var isUpgrade: Bool?
	var optionType: Int32?
	var physicalHeight: Float?
	var physicalWidth: Float?

	init(name: String, builderID: HomeBuilder.ID, categoryID: OptionCategory.ID, imagePath: String) {
		self.name = name
		self.builderID = builderID
		self.categoryID = categoryID
		self.optionImageURL = imagePath
	}
}

extension OptionItem: PostgreSQLUUIDModel {}

extension OptionItem: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { homeOption in
			
			try addProperties(to: homeOption)
			
			homeOption.reference(from: \.builderID, to: \HomeBuilder.id)
			
			homeOption.reference(from: \.categoryID, to: \OptionCategory.id)
		}
	}
	
}

extension OptionItem: Content {}

extension OptionItem: Parameter {}

extension OptionItem
{
	var builder: Parent<OptionItem, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var category: Parent<OptionItem, OptionCategory> {
		
		return parent(\.categoryID)
	}
	
	var images: Siblings<OptionItem, ImageAsset, ImageAssetHomeOptionPivot> {
		
		return siblings()
	}


}



