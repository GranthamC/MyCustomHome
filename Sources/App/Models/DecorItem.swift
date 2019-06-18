import Foundation
import Vapor
import FluentPostgreSQL

final class DecorItem: Codable
{
	var id: UUID?
	
	var itemID: String

	var name: String
	
	var plantID: String?
	var plantModelID: Plant.ID
	
	var categoryID: String?
	var categoryModelID: DecorCategory.ID

	var optionImageURL: String

	var changeToken: Int32?

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
	
	init(name: String, plantID: Plant.ID, categoryID: DecorCategory.ID, imagePath: String, itemID: String) {
		self.name = name
		self.plantModelID = plantID
		self.categoryModelID = categoryID
		self.optionImageURL = imagePath
		self.itemID = itemID
	}
}

extension DecorItem: PostgreSQLUUIDModel {}

extension DecorItem: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)

			builder.reference(from: \.plantModelID, to: \Plant.id)
			
			builder.reference(from: \.categoryModelID, to: \DecorCategory.id)
		}
	}
	
}

extension DecorItem: Content {}

extension DecorItem: Parameter {}

extension DecorItem
{
	var builder: Parent<DecorItem, Plant> {
		
		return parent(\.plantModelID)
	}
	
	
	var category: Parent<DecorItem, DecorCategory> {
		
		return parent(\.categoryModelID)
	}

	var images: Siblings<DecorItem, Image, ImageAssetDecorItemPivot> {
		
		return siblings()
	}
	
	var decorMedia: Children<DecorItem, DecorMedia> {
		
		return children(\.decorItemID)
	}

}




