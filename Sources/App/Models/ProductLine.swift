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
	
	init(name: String, builderID: HomeBuilder.ID) {
		
		self.name = name
		self.builderID = builderID
	}
}

extension ProductLine: PostgreSQLUUIDModel {}

extension ProductLine: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {

		return Database.create(self, on: connection) { line in

			try addProperties(to: line)

			line.reference(from: \.builderID, to: \HomeBuilder.id)
		}
	}
	
}

extension ProductLine: Content {}

extension ProductLine: Parameter {}

extension ProductLine
{
	var homeModels: Siblings<ProductLine, HomeModel, ProductLineHomeModelPivot> {
		
		return siblings()
	}
	
	var builder: Parent<ProductLine, HomeBuilder> {

		return parent(\.builderID)
	}
}
