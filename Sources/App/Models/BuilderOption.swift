import Foundation
import Vapor
import FluentPostgreSQL

final class BuilderOption: Codable
{
	var id: UUID?
	
	var name: String
	var plantID: Plant.ID
	
	var categoryID: PlantCategory.ID

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

	init(name: String, plantID: Plant.ID, categoryID: PlantCategory.ID, imagePath: String) {
		self.name = name
		self.plantID = plantID
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

			homeOption.reference(from: \.plantID, to: \Plant.id)
			
			homeOption.reference(from: \.categoryID, to: \PlantCategory.id)
		}
	}
	
}

extension BuilderOption: Content {}

extension BuilderOption: Parameter {}

extension BuilderOption
{
	var builder: Parent<BuilderOption, Plant> {
		
		return parent(\.plantID)
	}
	
	var category: Parent<BuilderOption, PlantCategory> {
		
		return parent(\.categoryID)
	}
	
	var images: Siblings<BuilderOption, Image, ImageAssetHomeOptionPivot> {
		
		return siblings()
	}


}



