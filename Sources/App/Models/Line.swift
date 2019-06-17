import Foundation
import Vapor
import FluentPostgreSQL

final class Line: Codable
{
	var id: UUID?
	var name: String
	var builderID: Plant.ID
	
	var changeToken: Int32?

	var logoURL: String?
	
	var websiteURL: String?
	
	init(name: String, builderID: Plant.ID) {
		
		self.name = name
		self.builderID = builderID
	}
}

extension Line: PostgreSQLUUIDModel {}

extension Line: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {

		return Database.create(self, on: connection) { line in

			try addProperties(to: line)

			line.reference(from: \.builderID, to: \Plant.id)
			
			line.unique(on: \.name)
		}
	}
}


extension Line: Content {}

extension Line: Parameter {}

extension Line
{
	var homeModels: Siblings<Line, HomeModel, ProductLineHomeModelPivot> {
		
		return siblings()
	}
	
	var decorCategories: Children<Line, LineDecorCategory> {
		
		return children(\.lineID)
	}
	
	var decorPackages: Siblings<Line, DecorPackage, ProductLineDecorPackagePivot> {
		
		return siblings()
	}

	var builder: Parent<Line, Plant> {

		return parent(\.builderID)
	}
}
