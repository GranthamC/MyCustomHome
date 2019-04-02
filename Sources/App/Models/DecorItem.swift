import Foundation
import Vapor
import FluentPostgreSQL

final class DecorItem: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	
	var categoryID: DecorCategory.ID

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
	
	init(name: String, builderID: HomeBuilder.ID, categoryID: DecorCategory.ID, imagePath: String) {
		self.name = name
		self.builderID = builderID
		self.categoryID = categoryID
		self.optionImageURL = imagePath
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
			
//			builder.unique(on: \.name)

			builder.reference(from: \.builderID, to: \HomeBuilder.id)
			
			builder.reference(from: \.categoryID, to: \DecorCategory.id)
		}
	}
	
}

extension DecorItem: Content {}

extension DecorItem: Parameter {}

extension DecorItem
{
	var builder: Parent<DecorItem, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var category: Parent<DecorItem, DecorCategory> {
		
		return parent(\.categoryID)
	}

	var images: Siblings<DecorItem, ImageAsset, ImageAssetDecorItemPivot> {
		
		return siblings()
	}
	
	
}




