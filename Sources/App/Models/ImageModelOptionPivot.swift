import FluentPostgreSQL
import Foundation


final class ImageModelOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var imageAssetID: Image.ID
	var modelOptionID: ModelOption.ID
	
	
	typealias Left = Image
	typealias Right = ModelOption
	
	static let leftIDKey: LeftIDKey = \.imageAssetID
	static let rightIDKey: RightIDKey = \.modelOptionID
	
	
	init(_ image: Image, _ modelOption: ModelOption) throws {
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
			
			builder.reference(from: \.imageAssetID, to: \Image.id, onDelete: .cascade)
			
			builder.reference(from: \.modelOptionID, to: \ModelOption.id, onDelete: .cascade)
		}
	}
	
}




