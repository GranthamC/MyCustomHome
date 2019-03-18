import FluentPostgreSQL
import Vapor


struct AddModelSetCategory: Migration {
	
	typealias Database = PostgreSQLDatabase
	
	static func prepare( on connection: PostgreSQLConnection ) -> Future<Void>
	{
		return Database.create(	HomeSetCategory.self, on: connection	) { builder in
			
			builder.field(for: \.id, isIdentifier: true)
			
			builder.field(for: \.name)
			
			builder.field(for: \.homeSetID)
			
			builder.reference(from: \.homeSetID, to: \BuilderHomeSet.id)
		}
	}
	
	
	
	static func revert(	on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.delete(	HomeSetCategory.self, on: connection	)
	}
}

