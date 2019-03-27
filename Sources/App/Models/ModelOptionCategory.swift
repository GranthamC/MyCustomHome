import Foundation
import Vapor
import FluentPostgreSQL

final class ModelOptionCategory: Codable
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

extension ModelOptionCategory: PostgreSQLUUIDModel {}

extension ModelOptionCategory: Migration
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

extension ModelOptionCategory: Content {}

extension ModelOptionCategory: Parameter {}

extension ModelOptionCategory
{
	var homeModel: Parent<ModelOptionCategory, HomeModel> {
		
		return parent(\.modelID)
	}
	
	var optionItems: Children<ModelOptionCategory, ModelOption> {
		
		return children(\.categoryID)
	}
	
}






