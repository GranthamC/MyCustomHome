import Foundation
import Vapor
import FluentPostgreSQL

final class BuilderHomeSet: Codable
{
	var id: UUID?
	
	var setTitle: String
	
	var changeToken: Int32?
	
	var logoURL: String?
	
	var setDescription: String?
	
	var setIndex: Int16?
	
	var websiteURL: String?
	
	var orderByIndex: Bool?
	var useFactoryTour: Bool?
	var useSlideOverForHomeInfo: Bool?
	
	var homeSetBrochureURL: String?
	
	var useCategories: Bool?
	var useBrochure: Bool?

	init(name: String) {
		
		self.setTitle = name
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
	
	var homeCategories: Children<BuilderHomeSet, HomeSetCategory> {
		
		return children(\.homeSetID)
	}
}



