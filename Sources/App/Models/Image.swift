import Foundation
import Vapor
import FluentPostgreSQL




// MARK: Image Asset Type Enum and labels
//
enum AssetImageType: Int32 {
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
	var builderID: Plant.ID
	var assetImageURL: String
	
	var changeToken: Int32?

	var caption: String?
	var imageScale: Float?
	var assetImageType: Int32?
	
	init(assetImageURL: String, builderID: Plant.ID) {
		self.assetImageURL = assetImageURL
		self.builderID = builderID
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
			
			builder.reference(from: \.builderID, to: \Plant.id)
		}
	}
	
}

extension Image: Content {}

extension Image: Parameter {}

extension Image
{
	var builder: Parent<Image, Plant> {
		
		return parent(\.builderID)
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



