import Foundation
import Vapor
import FluentPostgreSQL

final class ModelOption: Codable
{
	var id: UUID?
	
	var name: String
	var modelID: HomeModel.ID
	var optionImageURL: String

	var detailInfo: String?
	
	var isUpgrade: Bool?
	var optionImageType: Int32?

	var optionModelURL: String?
	var optionTexCoordsURL: String?
	
	var optionColor: Int32?

	var imageScale: Float?
	var physicalHeight: Float?
	var physicalWidth: Float?

	var changeToken: Int32?

	init(name: String, modelID: HomeModel.ID, imagePath: String) {
		self.name = name
		self.modelID = modelID
		self.optionImageURL = imagePath
	}
}

extension ModelOption: PostgreSQLUUIDModel {}

extension ModelOption: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { homeOption in
			
			try addProperties(to: homeOption)
			
			homeOption.reference(from: \.modelID, to: \HomeModel.id)
		}
	}
	
}

extension ModelOption: Content {}

extension ModelOption: Parameter {}

extension ModelOption
{
	var homeModel: Parent<ModelOption, HomeModel> {
		
		return parent(\.modelID)
	}
	
	var images: Siblings<ModelOption, ImageAsset, ImageModelOptionPivot> {
		
		return siblings()
	}
	
}




