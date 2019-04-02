import Foundation
import Vapor
import FluentPostgreSQL

final class HM_DecorCategory: Codable
{
	var id: UUID?
	var name: String
	
	var modelID: HomeModel.ID
	
	var categoryID: LineDecorCategory.ID

	var optionType: Int32?
	
	var changeToken: Int32?
	
	init(name: String, modelID: HomeModel.ID, categoryID: LineDecorCategory.ID) {
		self.name = name
		self.modelID = modelID
		self.categoryID = categoryID
	}
}

extension HM_DecorCategory: PostgreSQLUUIDModel {}

extension HM_DecorCategory: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
//			builder.unique(on: \.name)
			
			builder.reference(from: \.modelID, to: \HomeModel.id)
			
			builder.reference(from: \.categoryID, to: \LineDecorCategory.id)
		}
	}
	
}

extension HM_DecorCategory: Content {}

extension HM_DecorCategory: Parameter {}

extension HM_DecorCategory
{
	var homeModel: Parent<HM_DecorCategory, HomeModel> {
		
		return parent(\.modelID)
	}
	
	
	var optionItems: Siblings<HM_DecorCategory, DecorItem, ModelCategoryItemPivot> {
		
		return siblings()
	}
	
}





