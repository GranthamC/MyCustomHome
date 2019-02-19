import FluentPostgreSQL
import Foundation


final class ImageModelOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var imageAssetID: ImageAsset.ID
	var modelOptionID: ModelOption.ID
	
	
	typealias Left = ImageAsset
	typealias Right = ModelOption
	
	static let leftIDKey: LeftIDKey = \.imageAssetID
	static let rightIDKey: RightIDKey = \.modelOptionID
	
	
	init(_ image: ImageAsset, _ modelOption: ModelOption) throws {
		self.imageAssetID = try image.requireID()
		self.modelOptionID = try modelOption.requireID()
	}
}


extension ImageModelOptionPivot: Migration
{
	static func prepare(on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.imageAssetID, to: \ImageAsset.id, onDelete: .cascade)
			
			builder.reference(from: \.modelOptionID, to: \ModelOption.id, onDelete: .cascade)
		}
	}
	
}




