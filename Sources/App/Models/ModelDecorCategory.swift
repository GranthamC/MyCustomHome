import Foundation
import Vapor
import FluentPostgreSQL

final class ModelDecorCategory: Codable
{
	var id: UUID?
	var name: String
	
	var modelID: HomeModel.ID
	
	var optionType: Int32?
	
	var changeToken: Int32?
	
	init(name: String, modelID: HomeModel.ID) {
		self.name = name
		self.modelID = modelID
	}
}

extension ModelDecorCategory: PostgreSQLUUIDModel {}

extension ModelDecorCategory: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
//			builder.unique(on: \.name)
			
			builder.reference(from: \.modelID, to: \HomeModel.id)
		}
	}
	
}

extension ModelDecorCategory: Content {}

extension ModelDecorCategory: Parameter {}

extension ModelDecorCategory
{
	var homeModel: Parent<ModelDecorCategory, HomeModel> {
		
		return parent(\.modelID)
	}
	
	
	var optionItems: Siblings<ModelDecorCategory, DecorItem, ModelCategoryItemPivot> {
		
		return siblings()
	}
	
}





