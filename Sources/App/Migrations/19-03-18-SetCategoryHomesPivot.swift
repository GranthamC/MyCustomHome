import FluentPostgreSQL
import Vapor


struct AddSetCategoryHomesPivot: Migration {
	
	typealias Database = PostgreSQLDatabase
	
	static func prepare(on connection: PostgreSQLConnection) -> Future<Void>
	{
		return Database.create(SetCategoryHomesPivot.self, on: connection) { builder in
			
			builder.field(for: \.id, isIdentifier: true)
			
			builder.field(for: \.setCategoryID)
			builder.field(for: \.homeModelID)
			
			builder.reference(from: \.setCategoryID, to: \HomeSetCategory.id, onDelete: .cascade)
			
			builder.reference(from: \.homeModelID, to: \HomeModel.id, onDelete: .cascade)
		}
	}
	
	
	static func revert(	on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.delete(	SetCategoryHomesPivot.self, on: connection	)
	}
}


