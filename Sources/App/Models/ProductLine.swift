import Foundation
import Vapor
import FluentPostgreSQL

final class ProductLine: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	var logoURL: String?
	
	var websiteURL: String?
	
	var lastUpdateBy: UUID?
	
	init(name: String, builderID: HomeBuilder.ID, userID: UUID?) {
		
		self.name = name
		self.builderID = builderID
		self.lastUpdateBy = userID
	}
}

extension ProductLine: PostgreSQLUUIDModel {}

extension ProductLine: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {

		return Database.create(self, on: connection) { builder in

			try addProperties(to: builder)

			builder.reference(from: \.builderID, to: \HomeBuilder.id)
		}
	}
	
}

extension ProductLine: Content {}

extension ProductLine: Parameter {}

extension ProductLine
{
	var homeModels: Children<ProductLine, HomeModel> {
		
		return children(\.productLineID)
	}

	var decorCategories: Children<ProductLine, LineDecorCategory> {
		
		return children(\.lineID)
	}
	
	var builder: Parent<ProductLine, HomeBuilder> {

		return parent(\.builderID)
	}
}
