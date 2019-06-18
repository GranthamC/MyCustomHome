import Foundation
import Vapor
import FluentPostgreSQL

final class DecorPackage: Codable
{
	var id: UUID?
	var name: String
	var plantID: Plant.ID
	
	var packageID: String?
	
	var changeToken: Int32?

	init(name: String, plantID: Plant.ID) {
		self.name = name
		self.plantID = plantID
	}
}

extension DecorPackage: PostgreSQLUUIDModel {}

extension DecorPackage: Migration
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

extension DecorPackage: Content {}

extension DecorPackage: Parameter {}

extension DecorPackage
{
	var builder: Parent<DecorPackage, Plant> {
		
		return parent(\.plantID)
	}
	
	var optionItems: Siblings<DecorPackage, DecorItem, DecorPackageOptionPivot> {
		
		return siblings()
	}
	
}



