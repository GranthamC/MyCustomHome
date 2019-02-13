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

	init(name: String, logoURL: String)
	{
		self.name = name
		self.logoURL = logoURL
	}
}

extension HomeBuilder: PostgreSQLUUIDModel {}

extension HomeBuilder: Migration {}

extension HomeBuilder: Content {}

extension HomeBuilder: Parameter {}

extension HomeBuilder
{
	var productLines: Children<HomeBuilder, ProductLine> {
		
		return children(\.builderID)
	}
	
	var homeModels: Children<HomeBuilder, HomeModel> {
		
		return children(\.builderID)
	}
	
	var homeOptionCategories: Children<HomeBuilder, HomeOptionCategory> {
		
		return children(\.builderID)
	}
	
	var homeOptions: Children<HomeBuilder, HomeOptionItem> {
		
		return children(\.builderID)
	}
	
	var decorOptionCategories: Children<HomeBuilder, DecorOptionCategory> {
		
		return children(\.builderID)
	}
	
	var decorOptions: Children<HomeBuilder, DecorOptionItem> {
		
		return children(\.builderID)
	}

	var imageAssets: Children<HomeBuilder, ImageAsset> {
		
		return children(\.builderID)
	}
	
	var decorPackages: Children<HomeBuilder, DecorPackage> {
		
		return children(\.builderID)
	}

}
