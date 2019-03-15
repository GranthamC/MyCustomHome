import FluentPostgreSQL
import Vapor


struct AddModelSetToBuilder: Migration {
	
	typealias Database = PostgreSQLDatabase
	
	static func prepare( on connection: PostgreSQLConnection ) -> Future<Void>
	{
		return Database.create(	BuilderHomeSet.self, on: connection	) { builder in

			builder.field(for: \.id, isIdentifier: true)
		}
	}
	

	
	static func revert(	on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.delete(	BuilderHomeSet.self, on: connection	)
	}
}
