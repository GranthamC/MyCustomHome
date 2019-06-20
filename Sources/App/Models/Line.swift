import Foundation
import Vapor
import FluentPostgreSQL

final class Line: Codable
{
	var id: UUID?
	var name: String
	var plantModelID: Plant.ID
	
	var changeToken: Int32?

	var logoURL: String?
	var websiteURL: String?

	var lineID: String
	var lineDescription: String?
	var acronym: String?
	
	var plantID: String?
	var plantNumber: String?

	init(name: String, lineID: String, plantModelID: Plant.ID) {
		
		self.name = name
		self.lineID = lineID
		self.plantModelID = plantModelID
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

			line.reference(from: \.plantModelID, to: \Plant.id)
			
			line.unique(on: \.lineID)
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
	
	var homes: Children<Line, HomeModel> {
		
		return children(\.lineModelID)
	}

	var decorCategories: Children<Line, LineDecorCategory> {
		
		return children(\.lineID)
	}
	
	var decorPackages: Siblings<Line, DecorPackage, ProductLineDecorPackagePivot> {
		
		return siblings()
	}

	var builder: Parent<Line, Plant> {

		return parent(\.plantModelID)
	}
}
