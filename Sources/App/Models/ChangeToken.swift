import Foundation
import Vapor
import FluentPostgreSQL

final class ChangeToken: Codable
{
	var id: UUID?
	var builderName: String
	var plantID: Plant.ID
	
	var builderToken: Int32?
	var decorItemToken: Int32?
	var decorPackageToken: Int32?
	var decorCategoryToken: Int32?
	var homeModelToken: Int32?
	var homeOptionToken: Int32?
	var homeOptionCategoryToken: Int32?
	var imageAssetToken: Int32?
	var productLineToken: Int32?
	
	var tokenOption1: Int32?
	var tokenOption2: Int32?
	var tokenOption3: Int32?
	var tokenOption4: Int32?
	var tokenOption5: Int32?
	

	init(name: String, plantID: Plant.ID) {
		self.builderName = name
		self.plantID = plantID
	}
}

extension ChangeToken: PostgreSQLUUIDModel {}

extension ChangeToken: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.plantID, to: \Plant.id)
		}
	}
	
}

extension ChangeToken: Content {}

extension ChangeToken: Parameter {}

extension ChangeToken
{
	var builder: Children<ChangeToken, Plant> {
		
		return children(\.changeTokensID)
	}

}

