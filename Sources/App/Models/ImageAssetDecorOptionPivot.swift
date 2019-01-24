import FluentPostgreSQL
import Foundation


final class ImageAssetDecorOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var imageAssetID: ImageAsset.ID
	var decorOptionID: DecorOptionItem.ID

	
	typealias Left = ImageAsset
	typealias Right = DecorOptionItem
	
	static let leftIDKey: LeftIDKey = \.imageAssetID
	static let rightIDKey: RightIDKey = \.decorOptionID
	
	
	init(_ image: ImageAsset, _ decorOption: DecorOptionItem) throws {
		self.imageAssetID = try image.requireID()
		self.decorOptionID = try decorOption.requireID()
	}
}


extension ImageAssetDecorOptionPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.imageAssetID, to: \ImageAsset.id, onDelete: .cascade)
			
			builder.reference(from: \.decorOptionID, to: \DecorOptionItem.id, onDelete: .cascade)
		}
	}
	
}


