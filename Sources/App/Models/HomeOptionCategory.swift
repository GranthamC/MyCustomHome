import Foundation
import Vapor
import FluentPostgreSQL

final class HomeOptionCategory: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID

	var optionType: Int64?

	init(name: String, builderID: HomeBuilder.ID) {
		self.name = name
		self.builderID = builderID
	}
}

extension HomeOptionCategory: PostgreSQLUUIDModel {}

extension HomeOptionCategory: Migration
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

extension HomeOptionCategory: Content {}

extension HomeOptionCategory: Parameter {}

extension HomeOptionCategory
{
	var builder: Parent<HomeOptionCategory, HomeBuilder> {
		
		return parent(\.builderID)
	}

	
}


