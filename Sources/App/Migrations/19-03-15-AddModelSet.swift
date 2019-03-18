import FluentPostgreSQL
import Vapor


struct AddModelSetToBuilder: Migration {
	
	typealias Database = PostgreSQLDatabase
	
	static func prepare( on connection: PostgreSQLConnection ) -> Future<Void>
	{
		return Database.create(	BuilderHomeSet.self, on: connection	) { builder in

			builder.field(for: \.id, isIdentifier: true)
			
			builder.field(for: \.setTitle)
			builder.unique(on: \.setTitle)
			
			builder.field(for: \.builderID)

			builder.field(for: \.changeToken)
			builder.field(for: \.logoURL)
			
			builder.field(for: \.setDescription)
			builder.field(for: \.setIndex)
			builder.field(for: \.websiteURL)
			
			builder.field(for: \.orderByIndex)
			builder.field(for: \.useFactoryTour)
			builder.field(for: \.useSlideOverForHomeInfo)
			
//			builder.field(for: \.homeSetBrochureURL)
//
//			builder.field(for: \.useCategories)
//			builder.field(for: \.useBrochure)

			builder.reference(from: \.builderID, to: \HomeBuilder.id)
		}
	}
	

	
	static func revert(	on connection: PostgreSQLConnection	) -> Future<Void>
	{
		return Database.delete(	BuilderHomeSet.self, on: connection	)
	}
}
