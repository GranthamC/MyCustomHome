import Foundation
import Vapor
import FluentPostgreSQL

final class HomeBuilder: Codable
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


extension HomeBuilder: PostgreSQLUUIDModel {}

extension HomeBuilder: Migration
{
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.unique(on: \.name)
		}
	}
}

extension HomeBuilder: Content {}

extension HomeBuilder: Parameter {}

extension HomeBuilder
{
	var changeTokens: Parent<HomeBuilder, ChangeToken> {
		
		return parent(\.changeTokensID!)
	}
	
	var productLines: Children<HomeBuilder, ProductLine> {
		
		return children(\.builderID)
	}
	
	var homeModels: Children<HomeBuilder, HomeModel> {
		
		return children(\.builderID)
	}
	
	var homeOptionCategories: Children<HomeBuilder, BuilderCategory> {
		
		return children(\.builderID)
	}
	
	var homeOptions: Children<HomeBuilder, BuilderOption> {
		
		return children(\.builderID)
	}
	
	var decorOptionCategories: Children<HomeBuilder, DecorCategory> {
		
		return children(\.builderID)
	}
	
	var decorOptions: Children<HomeBuilder, DecorItem> {
		
		return children(\.builderID)
	}

	var imageAssets: Children<HomeBuilder, ImageAsset> {
		
		return children(\.builderID)
	}
	
	var decorPackages: Children<HomeBuilder, DecorPackage> {
		
		return children(\.builderID)
	}
	
	var homeSets: Children<HomeBuilder, BuilderHomeSet> {
		
		return children(\.builderID)
	}

}
