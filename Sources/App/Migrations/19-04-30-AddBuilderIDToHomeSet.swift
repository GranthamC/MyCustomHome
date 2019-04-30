import FluentPostgreSQL
import Vapor

struct AddBuilderIDToHomeSet: Migration {
	
	typealias Database = PostgreSQLDatabase
	
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {

		return Database.update(
			BuilderHomeSet.self, on: connection
		) { builder in

			builder.field(for: \.builderID)
		}
	}
	

	static func revert(
		on connection: PostgreSQLConnection
		) -> Future<Void> {

		return Database.update(
			BuilderHomeSet.self, on: connection
		) { builder in

			builder.deleteField(for: \.builderID)
		}
	}
}
