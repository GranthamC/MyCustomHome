import FluentPostgreSQL
import Vapor
import Leaf
import Authentication

var adminName: String?
var adminPassword: String?


public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
	
	
    try services.register(FluentPostgreSQLProvider())

	try services.register(LeafProvider())
	
	try services.register(AuthenticationProvider())
	
    let router = EngineRouter.default()
	
    try routes(router)
	
    services.register(router, as: Router.self)
    
	var middlewares = MiddlewareConfig()
	
	let corsConfiguration = CORSMiddleware.Configuration(
		allowedOrigin: .all,
		allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
		allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
	)
	
	let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
	
	middlewares.use(corsMiddleware)
	
    middlewares.use(ErrorMiddleware.self)
	
    services.register(middlewares)
	
    var databases = DatabasesConfig()
	
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
	
    let username = Environment.get("DATABASE_USER") ?? "vapor"
	
    let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
	
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"
	
	adminName = Environment.get("MCH_ADMIN_USER")  ??  "vapor"
	
	adminPassword = Environment.get("MCH_ADMIN_PASSWORD")  ??  "password!"
	

    let databaseConfig = PostgreSQLDatabaseConfig(
        hostname: hostname,
        username: username,
        database: databaseName,
        password: password)
	
    let database = PostgreSQLDatabase(config: databaseConfig)
	
    databases.add(database: database, as: .psql)
	
    services.register(databases)
	
	// Create and register our database models
	//
    var migrations = MigrationConfig()

	migrations.add(model: User.self, database: .psql)
	
	migrations.add(model: Plant.self, database: .psql)
	
	migrations.add(model: ChangeToken.self, database: .psql)

	migrations.add(model: Line.self, database: .psql)

	migrations.add(model: PlantCategory.self, database: .psql)
	
	migrations.add(model: BuilderOption.self, database: .psql)

	migrations.add(model: DecorCategory.self, database: .psql)
	
	migrations.add(model: DecorItem.self, database: .psql)

	migrations.add(model: DecorMedia.self, database: .psql)

	migrations.add(model: HomeModel.self, database: .psql)

	migrations.add(model: DecorPackage.self, database: .psql)
	
	migrations.add(model: ModelOptionCategory.self, database: .psql)

	migrations.add(model: ModelOption.self, database: .psql)
	
	migrations.add(model: Image.self, database: .psql)

	migrations.add(model: DecorPackageOptionPivot.self, database: .psql)

	migrations.add(model: DecorCategoryItemPivot.self, database: .psql)

	migrations.add(model: HomeModelCategoryPivot.self, database: .psql)
	
	migrations.add(model: HomeModelOptionPivot.self, database: .psql)

	migrations.add(model: HomeModelDecorCategoryPivot.self, database: .psql)
	
	migrations.add(model: HomeModelDecorItemPivot.self, database: .psql)
	
	migrations.add(model: OptionCategoryItemPivot.self, database: .psql)

	migrations.add(model: ImageAssetHomeModelPivot.self, database: .psql)
	
	migrations.add(model: ImageAssetHomeOptionPivot.self, database: .psql)
	
	migrations.add(model: ImageAssetDecorItemPivot.self, database: .psql)
	
	migrations.add(model: ImageModelOptionPivot.self, database: .psql)

	migrations.add(model: ProductLineHomeModelPivot.self, database: .psql)
	
	migrations.add(model: ProductLineCategoryPivot.self, database: .psql)

	migrations.add(model: ProductLineDecorPackagePivot.self, database: .psql)
	
	migrations.add(model: ProductLineOptionPivot.self, database: .psql)

	migrations.add(model: Token.self, database: .psql)

	migrations.add(model: HomeModelSet.self, database: .psql)

	migrations.add(model: HomeSetCategory.self, database: .psql)

	migrations.add(model: HomeSetToHomeModelPivot.self, database: .psql)

	migrations.add(model: SetCategoryHomesPivot.self, database: .psql)

	migrations.add(model: LineDecorCategory.self, database: .psql)
	
	migrations.add(model: LineCategoryItemPivot.self, database: .psql)
	
	migrations.add(model: HM_DecorCategory.self, database: .psql)
	
	migrations.add(model: ModelCategoryItemPivot.self, database: .psql)
	
	
	migrations.add(model: HM_BdrOptCategory.self, database: .psql)
	
	migrations.add(model: HM_BdrOptionCategoryPivot.self, database: .psql)
	
	migrations.add(model: LineOptionCategory.self, database: .psql)
	
	migrations.add(model: LineCategoryOptionPivot.self, database: .psql)

	
	migrations.add(model: ProductSeries.self, database: .psql)
	
	migrations.add(model: ProductSeriesModelPivot.self, database: .psql)

	
	migrations.add(migration: AdminUser.self, database: .psql)
	
//	migrations.add(migration: AddBuilderIDToHomeSet.self, database: .psql)

    services.register(migrations)
	
	
//	BuilderHomeSet.defaultDatabase = DatabaseIdentifier<PostgreSQLDatabase>.psql
	
	
	config.prefer(LeafRenderer.self, for: ViewRenderer.self)

	// Add command line configuration service
	//
	var commandConfig = CommandConfig.default()

	commandConfig.useFluentCommands()

	services.register(commandConfig)
	
	
}
