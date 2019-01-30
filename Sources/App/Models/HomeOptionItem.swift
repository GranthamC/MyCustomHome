import Foundation
import Vapor
import FluentPostgreSQL

final class HomeOptionItem: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	var categoryID: HomeOptionCategory.ID

	var optionImageURL: String?
	
	var optionModelURL: String?
	
	var decorOptionColor: UInt32?
	var imageScale: Float?
	var isUpgrade: Bool?
	var optionType: Int64?
	var physicalHeight: Float?
	var physicalWidth: Float?

	init(name: String, builderID: HomeBuilder.ID, categoryID: HomeOptionCategory.ID) {
		self.name = name
		self.builderID = builderID
		self.categoryID = categoryID
	}
}

extension HomeOptionItem: PostgreSQLUUIDModel {}

extension HomeOptionItem: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { homeOption in
			
			try addProperties(to: homeOption)
			
			homeOption.reference(from: \.builderID, to: \HomeBuilder.id)
			
			homeOption.reference(from: \.categoryID, to: \HomeOptionCategory.id)
		}
	}
	
}

extension HomeOptionItem: Content {}

extension HomeOptionItem: Parameter {}

extension HomeOptionItem
{
	var builder: Parent<HomeOptionItem, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var optionCategory: Parent<HomeOptionItem, HomeOptionCategory> {
		
		return parent(\.categoryID)
	}
	

}



