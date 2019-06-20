import FluentPostgreSQL
import Vapor

struct AddBuilderIDToHomeSet: Migration {
	
	typealias Database = PostgreSQLDatabase
	
	static func prepare(
		on connection: PostgreSQLConnection
		) -> Future<Void> {

		return Database.update(
			HomeModelSet.self, on: connection
		) { builder in

			builder.field(for: \.plantID)
		}
	}
	

	static func revert(
		on connection: PostgreSQLConnection
		) -> Future<Void> {

		return Database.update(
			HomeModelSet.self, on: connection
		) { builder in

			builder.deleteField(for: \.plantID)
		}
	}
}
