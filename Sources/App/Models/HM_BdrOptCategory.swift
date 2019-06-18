import Foundation
import Vapor
import FluentPostgreSQL

final class HM_BdrOptCategory: Codable
{
	var id: UUID?
	var name: String
	
	var modelID: HomeModel.ID
	
	var categoryID: PlantCategory.ID

	var optionType: Int32?
	
	var optionCategoryID: String?
	
	var changeToken: Int32?
	
	init(name: String, modelID: HomeModel.ID, categoryID: PlantCategory.ID) {
		self.name = name
		self.modelID = modelID
		self.categoryID = categoryID
	}
}

extension HM_BdrOptCategory: PostgreSQLUUIDModel {}

extension HM_BdrOptCategory: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			//			builder.unique(on: \.name)
			
			builder.reference(from: \.modelID, to: \HomeModel.id)
			
			builder.reference(from: \.categoryID, to: \PlantCategory.id)
		}
	}
	
}

extension HM_BdrOptCategory: Content {}

extension HM_BdrOptCategory: Parameter {}

extension HM_BdrOptCategory
{
	var homeModel: Parent<HM_BdrOptCategory, HomeModel> {
		
		return parent(\.modelID)
	}
	
	
	var optionItems: Siblings<HM_BdrOptCategory, BuilderOption, HM_BdrOptionCategoryPivot> {
		
		return siblings()
	}
	
}






