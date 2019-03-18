import Foundation
import Vapor
import FluentPostgreSQL

final class HomeSetCategory: Codable
{
	var id: UUID?
	var name: String
	var homeSetID: BuilderHomeSet.ID
	
	init(name: String, homeSetID: BuilderHomeSet.ID) {
		
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
		
		return Database.create(self, on: connection) { line in
			
//			try addProperties(to: line)
//			
//			line.reference(from: \.homeSetID, to: \BuilderHomeSet.id)
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
	
	var homeSet: Parent<HomeSetCategory, BuilderHomeSet> {
		
		return parent(\.homeSetID)
	}
}

