import FluentPostgreSQL
import Foundation


final class ImageAssetDecorItemPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var imageAssetID: Image.ID
	var decorOptionID: DecorItem.ID
	
	
	typealias Left = Image
	typealias Right = DecorItem
	
	static let leftIDKey: LeftIDKey = \.imageAssetID
	static let rightIDKey: RightIDKey = \.decorOptionID
	
	
	init(_ image: Image, _ homeOption: DecorItem) throws {
		self.imageAssetID = try image.requireID()
		self.decorOptionID = try homeOption.requireID()
	}
}


extension ImageAssetDecorItemPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.imageAssetID, to: \Image.id, onDelete: .cascade)
			
			builder.reference(from: \.decorOptionID, to: \DecorItem.id, onDelete: .cascade)
		}
	}
	
}




