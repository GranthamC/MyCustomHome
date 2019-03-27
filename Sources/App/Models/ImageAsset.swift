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

final class ImageAsset: Codable
{
	var id: UUID?
	var builderID: HomeBuilder.ID
	var assetImageURL: String
	
	var changeToken: Int32?

	var caption: String?
	var imageScale: Float?
	var assetImageType: Int32?
	
	init(assetImageURL: String, builderID: HomeBuilder.ID) {
		self.assetImageURL = assetImageURL
		self.builderID = builderID
	}
}

extension ImageAsset: PostgreSQLUUIDModel {}

extension ImageAsset: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.builderID, to: \HomeBuilder.id)
		}
	}
	
}

extension ImageAsset: Content {}

extension ImageAsset: Parameter {}

extension ImageAsset
{
	var builder: Parent<ImageAsset, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var homeOptionExampleImages: Siblings<ImageAsset,
		BuilderOption,
		ImageAssetHomeOptionPivot> {
		
		return siblings()
	}
	
	var homeModelImages: Siblings<ImageAsset,
		HomeModel,
		ImageAssetHomeModelPivot> {
		
		return siblings()
	}
	
	var decorOptionImages: Siblings<ImageAsset,
		DecorItem,
		ImageAssetDecorItemPivot> {
		
		return siblings()
	}

}



