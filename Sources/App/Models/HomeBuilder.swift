import Foundation
import Vapor
import FluentPostgreSQL

final class HomeBuilder: Codable
{
	var id: UUID?
	var name: String
	var username: String
	var logoURL: String?
	var websiteURL: String?

	init(name: String, username: String) {
		self.name = name
		self.username = username
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
}
