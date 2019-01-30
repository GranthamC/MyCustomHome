import Foundation
import Vapor
import FluentPostgreSQL

final class HomeModelOptionCategory: Codable
{
	var id: UUID?
	var homeModelID: HomeModel.ID
	var categoryID: HomeOptionCategory.ID
	
	init(categoryID: HomeOptionCategory.ID, homeModelID: HomeModel.ID) {
		self.categoryID = categoryID
		self.homeModelID = homeModelID
	}
}

extension HomeModelOptionCategory: PostgreSQLUUIDModel {}

extension HomeModelOptionCategory: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { category in
			
			try addProperties(to: category)
			
			category.reference(from: \.homeModelID, to: \HomeModel.id)
			
			category.reference(from: \.categoryID, to: \HomeOptionCategory.id)
		}
	}
	
}

extension HomeModelOptionCategory: Content {}

extension HomeModelOptionCategory: Parameter {}

extension HomeModelOptionCategory
{
	var homeModel: Parent<HomeModelOptionCategory, HomeModel> {
		
		return parent(\.homeModelID)
	}
	
	var modelOptions: Children<HomeModelOptionCategory, HomeModelOptionItem> {
		
		return children(\.categoryID)
	}
	
}


