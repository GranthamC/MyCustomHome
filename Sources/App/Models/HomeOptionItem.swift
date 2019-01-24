import Foundation
import Vapor
import FluentPostgreSQL

final class HomeOptionItem: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	
	var optionImageURL: String?
	
	var optionModelURL: String?
	
	var decorOptionColor: UInt32?
	var imageScale: Float?
	var isUpgrade: Bool?
	var optionType: Int64?
	var physicalHeight: Float?
	var physicalWidth: Float?

	init(name: String, builderID: HomeBuilder.ID) {
		self.name = name
		self.builderID = builderID
	}
}

extension HomeOptionItem: PostgreSQLUUIDModel {}

extension HomeOptionItem: Migration
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

extension HomeOptionItem: Content {}

extension HomeOptionItem: Parameter {}

extension HomeOptionItem
{
	var builder: Parent<HomeOptionItem, HomeBuilder> {
		
		return parent(\.builderID)
	}
	
	var categories: Siblings<HomeOptionItem,
		HomeOptionCategory,
		HomeOptionCategoryPivot> {
		
		return siblings()
	}
	
	var homeModels: Siblings<HomeOptionItem,
		HomeModel,
		HomeOptionHomeModelPivot> {
		
		return siblings()
	}

}



