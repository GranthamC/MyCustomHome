import Foundation
import Vapor
import FluentPostgreSQL

final class BuilderOption: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	
	var categoryID: BuilderCategory.ID

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

	init(name: String, builderID: HomeBuilder.ID, categoryID: BuilderCategory.ID, imagePath: String) {
		self.name = name
		self.builderID = builderID
		self.categoryID = categoryID
		self.optionImageURL = imagePath
	}
}

extension BuilderOption: PostgreSQLUUIDModel {}

extension BuilderOption: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { homeOption in
			
			try addProperties(to: homeOption)
			
			homeOption.unique(on: \.name)

			homeOption.reference(from: \.builderID, to: \HomeBuilder.id)
			
			homeOption.reference(from: \.categoryID, to: \BuilderCategory.id)
		}
	}
	
}

extension BuilderOption: Content {}

extension BuilderOption: Parameter {}

extension BuilderOption
{
	var builder: Parent<BuilderOption, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var category: Parent<BuilderOption, BuilderCategory> {
		
		return parent(\.categoryID)
	}
	
	var images: Siblings<BuilderOption, ImageAsset, ImageAssetHomeOptionPivot> {
		
		return siblings()
	}


}



