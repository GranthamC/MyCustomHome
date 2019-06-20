import FluentPostgreSQL
import Foundation


final class ImageAssetHomeOptionPivot: PostgreSQLUUIDPivot, ModifiablePivot
{
	var id: UUID?
	
	var imageAssetID: Image.ID
	var homeOptionID: BuilderOption.ID
	
	
	typealias Left = Image
	typealias Right = BuilderOption
	
	static let leftIDKey: LeftIDKey = \.imageAssetID
	static let rightIDKey: RightIDKey = \.homeOptionID
	
	
	init(_ image: Image, _ homeOption: BuilderOption) throws {
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
			
			builder.reference(from: \.imageAssetID, to: \Image.id, onDelete: .cascade)
			
			builder.reference(from: \.homeOptionID, to: \BuilderOption.id, onDelete: .cascade)
		}
	}
	
}



