import Foundation
import Vapor
import FluentPostgreSQL

final class HomeBuilder: Codable
{
	var id: UUID?
	
	var name: String
	var username: String
	var userUpdateID: UUID
	
	var logoURL: String?
	var websiteURL: String?

	init(name: String, username: String, userID: UUID)
	{
		self.name = name
		self.username = username
		self.userUpdateID = userID
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
	
	var decorCategories: Children<HomeBuilder, DecorOptionCategory> {
		
		return children(\.builderID)
	}
	
	var decorOptions: Children<HomeBuilder, DecorOptionItem> {
		
		return children(\.builderID)
	}
	
	var homeOptionCategories: Children<HomeBuilder, HomeOptionCategory> {
		
		return children(\.builderID)
	}
	
	var homeOptions: Children<HomeBuilder, HomeOptionItem> {
		
		return children(\.builderID)
	}
	
	var imageAssets: Children<HomeBuilder, ImageAsset> {
		
		return children(\.builderID)
	}

}
