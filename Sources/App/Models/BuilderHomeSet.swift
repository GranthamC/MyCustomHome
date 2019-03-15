import Foundation
import Vapor
import FluentPostgreSQL

final class BuilderHomeSet: Codable
{
	var id: UUID?
	
	var setTitle: String
	var builderID: HomeBuilder.ID
	
	var changeToken: Int32?
	
	var logoURL: String?
	
	var setDescription: String?
	
	var setIndex: Int16?
	
	var websiteURL: String?
	
	var orderByIndex: Bool?
	var useFactoryTour: Bool?
	var useSlideOverForHomeInfo: Bool?
	
	init(name: String, builderID: HomeBuilder.ID) {
		
		self.setTitle = name
		self.builderID = builderID
	}
}

extension BuilderHomeSet: PostgreSQLUUIDModel {}

extension BuilderHomeSet: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			try addProperties(to: builder)
			
			builder.reference(from: \.builderID, to: \HomeBuilder.id)
			
			builder.unique(on: \.setTitle)
		}
	}
}


extension BuilderHomeSet: Content {}

extension BuilderHomeSet: Parameter {}


extension BuilderHomeSet
{
	var homeModels: Siblings<BuilderHomeSet, HomeModel, HomeSetToHomeModelPivot> {
		
		return siblings()
	}
	
	var builder: Parent<BuilderHomeSet, HomeBuilder> {
		
		return parent(\.builderID)
	}
}



