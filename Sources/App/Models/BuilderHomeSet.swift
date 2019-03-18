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
	
	var homeSetBrochureURL: String?
	
	var useCategories: Bool?
	var useBrochure: Bool?

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
			
			builder.field(for: \.id, isIdentifier: true)

			builder.field(for: \.builderID)

			builder.field(for: \.setTitle)
			builder.unique(on: \.setTitle)

			builder.field(for: \.changeToken)
			builder.field(for: \.logoURL)

			builder.field(for: \.setDescription)
			builder.field(for: \.setIndex)
			builder.field(for: \.websiteURL)

			builder.field(for: \.orderByIndex)
			builder.field(for: \.useFactoryTour)
			builder.field(for: \.useSlideOverForHomeInfo)
			
			builder.field(for: \.homeSetBrochureURL)
			
			builder.field(for: \.useCategories)
			builder.field(for: \.useBrochure)

			builder.reference(from: \.builderID, to: \HomeBuilder.id)
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

	var builder: Parent<BuilderHomeSet, HomeBuilder> {
		
		return parent(\.builderID)
	}
}



