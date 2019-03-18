import FluentPostgreSQL
import Vapor


struct AddModelSetFieldsForCategory: Migration {
	
	typealias Database = PostgreSQLDatabase
	
	static func prepare( on connection: PostgreSQLConnection ) -> Future<Void>
	{
		return Database.update(	BuilderHomeSet.self, on: connection	) { builder in
			
			builder.field(for: \.homeSetBrochureURL)
			
			builder.field(for: \.useCategories)
			builder.field(for: \.useBrochure)
		}
	}
	
	
	static func revert(	on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.update(	BuilderHomeSet.self, on: connection	) { builder in
			
			builder.deleteField(for: \.homeSetBrochureURL)
			
			builder.deleteField(for: \.useCategories)
			builder.deleteField(for: \.useBrochure)
		}
	}
}

