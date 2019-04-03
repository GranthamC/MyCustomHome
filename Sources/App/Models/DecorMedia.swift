import Foundation
import Vapor
import FluentPostgreSQL

final class DecorMedia: Codable
{
	var id: UUID?
	
	var name: String
	var decorItemID: DecorItem.ID
	
	var optionImageURL: String
	
	var changeToken: Int32?
	
	var optionModelURL: String?
	
	var optionColor: Int32?

	var optionImageType: Int32?

	var imageScale: Float?
	var physicalHeight: Float?
	var physicalWidth: Float?
	
	init(name: String, itemID: DecorItem.ID, imagePath: String) {
		self.name = name
		self.decorItemID = itemID
		self.optionImageURL = imagePath
	}
}

extension DecorMedia: PostgreSQLUUIDModel {}

extension DecorMedia: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
//			builder.unique(on: \.name)
			
			builder.reference(from: \.decorItemID, to: \DecorItem.id)
			
		}
	}
	
}

extension DecorMedia: Content {}

extension DecorMedia: Parameter {}

extension DecorMedia
{
	var decorItem: Parent<DecorMedia, DecorItem> {
		
		return parent(\.decorItemID)
	}
	
}





