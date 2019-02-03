import Foundation
import Vapor
import FluentPostgreSQL

final class ImageAsset: Codable
{
	var id: UUID?
	var builderID: HomeBuilder.ID
	var assetImageURL: String
	
	var caption: String?
	var imageScale: Float?
	var assetImageType: Int64?
	
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
		HomeOptionItem,
		ImageAssetHomeOptionPivot> {
		
		return siblings()
	}
	
	var homeModelImages: Siblings<ImageAsset,
		HomeModel,
		ImageAssetHomeModelPivot> {
		
		return siblings()
	}

}



