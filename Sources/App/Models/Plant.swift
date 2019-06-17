import Foundation
import Vapor
import FluentPostgreSQL

final class Plant: Codable
{
	var id: UUID?
	
	var name: String
	var logoURL: String
	
	var websiteURL: String?
	
	var changeToken: Int32?
	
	var changeTokensID: ChangeToken.ID?

	init(name: String, logoURL: String)
	{
		self.name = name
		self.logoURL = logoURL
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
	
	var productLines: Children<Plant, ProductLine> {
		
		return children(\.builderID)
	}
	
	var homeModels: Children<Plant, HomeModel> {
		
		return children(\.builderID)
	}
	
	var homeOptionCategories: Children<Plant, BuilderCategory> {
		
		return children(\.builderID)
	}
	
	var homeOptions: Children<Plant, BuilderOption> {
		
		return children(\.builderID)
	}
	
	var decorOptionCategories: Children<Plant, DecorCategory> {
		
		return children(\.builderID)
	}
	
	var decorOptions: Children<Plant, DecorItem> {
		
		return children(\.builderID)
	}

	var imageAssets: Children<Plant, ImageAsset> {
		
		return children(\.builderID)
	}
	
	var decorPackages: Children<Plant, DecorPackage> {
		
		return children(\.builderID)
	}
	
	var homeSets: Children<Plant, BuilderHomeSet> {
		
		return children(\.builderID)
	}

}
