import FluentPostgreSQL
import Vapor


struct AddHomeSetPivot: Migration {
	
	typealias Database = PostgreSQLDatabase
	
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(HomeSetToHomeModelPivot.self, on: connection) { builder in
			
			builder.field(for: \.id, isIdentifier: true)

			builder.field(for: \.homeSetID)
			builder.field(for: \.homeModelID)

			builder.reference(from: \.homeSetID, to: \BuilderHomeSet.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
	
	
	static func revert(	on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.delete(	HomeSetToHomeModelPivot.self, on: connection	)
	}
}

