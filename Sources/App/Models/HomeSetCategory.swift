import Foundation
import Vapor
import FluentPostgreSQL

final class HomeSetCategory: Codable
{
	var id: UUID?
	var name: String
	var homeSetID: HomeModelSet.ID
	
	init(name: String, homeSetID: HomeModelSet.ID) {
		
		self.name = name
		self.homeSetID = homeSetID
	}
}

extension HomeSetCategory: PostgreSQLUUIDModel {}

extension HomeSetCategory: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.homeSetID, to: \HomeModelSet.id)
		}
	}
}


extension HomeSetCategory: Content {}

extension HomeSetCategory: Parameter {}

extension HomeSetCategory
{
	var homeModels: Siblings<HomeSetCategory, HomeModel, SetCategoryHomesPivot> {
		
		return siblings()
	}
	
	var homeSet: Parent<HomeSetCategory, HomeModelSet> {
		
		return parent(\.homeSetID)
	}
}

