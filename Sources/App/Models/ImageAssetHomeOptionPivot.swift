import FluentPostgreSQL
import Foundation


final class ImageAssetHomeOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var imageAssetID: ImageAsset.ID
	var homeOptionID: HomeOptionItem.ID
	
	
	typealias Left = ImageAsset
	typealias Right = HomeOptionItem
	
	static let leftIDKey: LeftIDKey = \.imageAssetID
	static let rightIDKey: RightIDKey = \.homeOptionID
	
	
	init(_ image: ImageAsset, _ homeOption: HomeOptionItem) throws {
		self.imageAssetID = try image.requireID()
		self.homeOptionID = try homeOption.requireID()
	}
}


extension ImageAssetHomeOptionPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.imageAssetID, to: \ImageAsset.id, onDelete: .cascade)
			
			builder.reference(from: \.homeOptionID, to: \HomeOptionItem.id, onDelete: .cascade)
		}
	}
	
}



