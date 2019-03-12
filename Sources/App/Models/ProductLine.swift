import Foundation
import Vapor
import FluentPostgreSQL

final class ProductLine: Codable
{
	var id: UUID?
	var name: String
	var builderID: HomeBuilder.ID
	
	var changeToken: Int32?

	var logoURL: String?
	
	var websiteURL: String?
	
	init(name: String, builderID: HomeBuilder.ID) {
		
		self.name = name
		self.builderID = builderID
	}
}

extension ProductLine: PostgreSQLUUIDModel {}

extension ProductLine: Migration
{
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {

		return Database.create(self, on: connection) { line in

			try addProperties(to: line)

			line.reference(from: \.builderID, to: \HomeBuilder.id)
			
			line.unique(on: \.name)
		}
	}
}


extension ProductLine: Content {}

extension ProductLine: Parameter {}

extension ProductLine
{
	var homeModels: Siblings<ProductLine, HomeModel, ProductLineHomeModelPivot> {
		
		return siblings()
	}
	
	var decorCategories: Siblings<ProductLine, DecorCategory, ProductLineCategoryPivot> {
		
		return siblings()
	}
	
	var decorItems: Siblings<ProductLine, DecorItem, ProductLineOptionPivot> {
		
		return siblings()
	}
	
	var decorPackages: Siblings<ProductLine, DecorPackage, ProductLineDecorPackagePivot> {
		
		return siblings()
	}

	var builder: Parent<ProductLine, HomeBuilder> {

		return parent(\.builderID)
	}
}
