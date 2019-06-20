import Foundation
import Vapor
import FluentPostgreSQL




// MARK: Image Asset Type Enum and labels
//
enum imageType: Int32 {
	case HomeImage = 0
	case DecorSwatch = 1
	case DecorOptionTexture = 2
	case BuilderOptionTexture = 3
	case ModelOptionTexture = 4
	case ObjectModelTexture = 5
}

final class Image: Codable
{
	var id: UUID?
	var plantID: Plant.ID
	var imageURL: String
	
	var imageID: String?
	
	var changeToken: Int32?

	var caption: String?
	var imageScale: Float?
	var imageType: Int32?
	
	init(imageURL: String, plantID: Plant.ID) {
		self.imageURL = imageURL
		self.plantID = plantID
	}
}

extension Image: PostgreSQLUUIDModel {}

extension Image: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.plantID, to: \Plant.id)
		}
	}
	
}

extension Image: Content {}

extension Image: Parameter {}

extension Image
{
	var builder: Parent<Image, Plant> {
		
		return parent(\.plantID)
	}
	
	var homeOptionExampleImages: Siblings<Image,
		BuilderOption,
		ImageAssetHomeOptionPivot> {
		
		return siblings()
	}
	
	var homeModelImages: Siblings<Image,
		HomeModel,
		ImageAssetHomeModelPivot> {
		
		return siblings()
	}
	
	var decorOptionImages: Siblings<Image,
		DecorItem,
		ImageAssetDecorItemPivot> {
		
		return siblings()
	}

}



