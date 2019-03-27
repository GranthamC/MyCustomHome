import Foundation
import Vapor
import FluentPostgreSQL

final class BuilderOptionItem: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	
	var categoryID: BuilderOptionCategory.ID

	var changeToken: Int32?

	var optionImageURL: String
	
	var optionModelURL: String?
	
	var manufacturerURL: String?
	var productID: String?

	var detailInfo: String?
	
	var optionColor: Int32?
	var imageScale: Float?
	var isUpgrade: Bool?
	var optionImageType: Int32?
	var physicalHeight: Float?
	var physicalWidth: Float?

	init(name: String, builderID: HomeBuilder.ID, categoryID: BuilderOptionCategory.ID, imagePath: String) {
		self.name = name
		self.builderID = builderID
		self.categoryID = categoryID
		self.optionImageURL = imagePath
	}
}

extension BuilderOptionItem: PostgreSQLUUIDModel {}

extension BuilderOptionItem: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { homeOption in
			
			try addProperties(to: homeOption)
			
			homeOption.unique(on: \.name)

			homeOption.reference(from: \.builderID, to: \HomeBuilder.id)
			
			homeOption.reference(from: \.categoryID, to: \BuilderOptionCategory.id)
		}
	}
	
}

extension BuilderOptionItem: Content {}

extension BuilderOptionItem: Parameter {}

extension BuilderOptionItem
{
	var builder: Parent<BuilderOptionItem, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var category: Parent<BuilderOptionItem, BuilderOptionCategory> {
		
		return parent(\.categoryID)
	}
	
	var images: Siblings<BuilderOptionItem, ImageAsset, ImageAssetHomeOptionPivot> {
		
		return siblings()
	}


}



