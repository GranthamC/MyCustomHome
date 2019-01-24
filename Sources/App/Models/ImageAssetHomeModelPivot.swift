import FluentPostgreSQL
import Foundation


final class ImageAssetHomeModelPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var imageAssetID: ImageAsset.ID
	var homeModelID: HomeModel.ID
	
	
	typealias Left = ImageAsset
	typealias Right = HomeModel
	
	static let leftIDKey: LeftIDKey = \.imageAssetID
	static let rightIDKey: RightIDKey = \.homeModelID
	
	
	init(_ image: ImageAsset, _ model: HomeModel) throws {
		self.imageAssetID = try image.requireID()
		self.homeModelID = try model.requireID()
	}
}


extension ImageAssetHomeModelPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.imageAssetID, to: \ImageAsset.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
	
}




