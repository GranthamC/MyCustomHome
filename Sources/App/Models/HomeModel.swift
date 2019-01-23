import Foundation
import Vapor
import FluentPostgreSQL

final class HomeModel: Codable
{
	var id: UUID?
	var name: String
	var productLineID: ProductLine.ID
	var logoURL: String?
	
	init(name: String, productLineID: ProductLine.ID) {
		self.name = name
		self.productLineID = productLineID
	}
}

extension HomeModel: PostgreSQLUUIDModel {}

extension HomeModel: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.productLineID, to: \HomeBuilder.id)
		}
	}
	
}

extension HomeModel: Content {}

extension HomeModel: Parameter {}

extension HomeModel
{
	var productLine: Parent<HomeModel, ProductLine> {
		
		return parent(\.productLineID)
	}
	
	var homeOptions: Siblings<HomeModel, HomeOptionItem, HomeOptionHomeModelPivot> {
		
		return siblings()
	}

}

