import Foundation
import Vapor
import FluentPostgreSQL

final class ModelOption: Codable
{
	var id: UUID?
	
	var name: String
	var optionID: String?
	
	var modelID: HomeModel.ID
	
	var categoryID: ModelOptionCategory.ID

	var optionImageURL: String

	var changeToken: Int32?

	var detailInfo: String?
	
	var isUpgrade: Bool?
	var optionImageType: Int32?

	var optionModelURL: String?
	var optionTexCoordsURL: String?
	
	var optionColor: Int32?

	var imageScale: Float?
	var physicalHeight: Float?
	var physicalWidth: Float?

	init(name: String, modelID: HomeModel.ID, categoryID: ModelOptionCategory.ID, imagePath: String) {
		self.name = name
		self.modelID = modelID
		self.categoryID = categoryID
		self.optionImageURL = imagePath
	}
}

extension ModelOption: PostgreSQLUUIDModel {}

extension ModelOption: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.modelID, to: \HomeModel.id)
			
			builder.reference(from: \.categoryID, to: \ModelOptionCategory.id)
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
	
	var category: Parent<ModelOption, ModelOptionCategory> {
		
		return parent(\.categoryID)
	}
	
	var images: Siblings<ModelOption, Image, ImageModelOptionPivot> {
		
		return siblings()
	}
	
}




