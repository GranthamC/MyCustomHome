import Foundation
import Vapor
import FluentPostgreSQL

final class HomeModelSet: Codable
{
	var id: UUID?
	
	var builderID: Plant.ID?

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

	init(title: String, builderID: Plant.ID?) {
		
		self.setTitle = title
		self.builderID = builderID
	}
}

extension HomeModelSet: PostgreSQLUUIDModel {}

extension HomeModelSet: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {
		
		return Database.create(self, on: connection) { builder in
			
			builder.field(for: \.id, isIdentifier: true)
			
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

			builder.field(for: \.builderID)

			builder.reference(from: \.builderID, to: \Plant.id)

		}
	}
}


extension HomeModelSet: Content {}

extension HomeModelSet: Parameter {}


extension HomeModelSet
{
	var builder: Parent<HomeModelSet, Plant> {
		return parent(\.builderID)!
	}
	
	var homeModels: Siblings<HomeModelSet, HomeModel, HomeSetToHomeModelPivot> {
		
		return siblings()
	}
	
	var homeCategories: Children<HomeModelSet, HomeSetCategory> {
		
		return children(\.homeSetID)
	}
}



