import Foundation
import Vapor
import FluentPostgreSQL

final class HomeOptionItem: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID

	var optionImageURL: String
	
	var optionModelURL: String?
	
	var description: String?
	
	var optionColor: Int64?
	var imageScale: Float?
	var isUpgrade: Bool?
	var optionType: Int64?
	var physicalHeight: Float?
	var physicalWidth: Float?

	init(name: String, builderID: HomeBuilder.ID, imagePath: String) {
		self.name = name
		self.builderID = builderID
		self.optionImageURL = imagePath
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
	
	var images: Siblings<HomeOptionItem, ImageAsset, ImageAssetHomeOptionPivot> {
		
		return siblings()
	}


}



