import Foundation
import Vapor
import FluentPostgreSQL

final class Plant: Codable
{
	var id: UUID?
	
	var name: String
	var logoURL: String?
	
	var plantID: String?
	var plantName: String?
	var plantNumber: String

	var websiteURL: String?
	
	var changeToken: Int32?
	
	var changeTokensID: ChangeToken.ID?

	init(name: String, plantNumber: String)
	{
		self.name = name
		self.plantNumber = plantNumber
	}
}


extension Plant: PostgreSQLUUIDModel {}

extension Plant: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.unique(on: \.name)
		}
	}
}

extension Plant: Content {}

extension Plant: Parameter {}

extension Plant
{
	var changeTokens: Parent<Plant, ChangeToken> {
		
		return parent(\.changeTokensID!)
	}
	
	var productLines: Children<Plant, Line> {
		
		return children(\.plantModelID)
	}
	
	var homeModels: Children<Plant, HomeModel> {
		
		return children(\.plantModelID)
	}
	
	var homeOptionCategories: Children<Plant, PlantCategory> {
		
		return children(\.plantID)
	}
	
	var homeOptions: Children<Plant, BuilderOption> {
		
		return children(\.plantID)
	}
	
	var decorOptionCategories: Children<Plant, DecorCategory> {
		
		return children(\.plantModelID)
	}
	
	var decorOptions: Children<Plant, DecorItem> {
		
		return children(\.plantModelID)
	}

	var images: Children<Plant, Image> {
		
		return children(\.plantID)
	}
	
	var decorPackages: Children<Plant, DecorPackage> {
		
		return children(\.plantID)
	}
	
	var homeSets: Children<Plant, HomeModelSet> {
		
		return children(\.plantID)
	}

}
