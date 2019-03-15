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
	
	migrations.add(model: HomeBuilder.self, database: .psql)
	
	migrations.add(model: ProductLine.self, database: .psql)
	
	migrations.add(model: ImageAsset.self, database: .psql)

	migrations.add(model: OptionCategory.self, database: .psql)
	
	migrations.add(model: OptionItem.self, database: .psql)

	migrations.add(model: DecorCategory.self, database: .psql)
	
	migrations.add(model: DecorItem.self, database: .psql)

	migrations.add(model: HomeModel.self, database: .psql)
	
	migrations.add(model: DecorPackage.self, database: .psql)
	
	migrations.add(model: ChangeToken.self, database: .psql)
	
	migrations.add(model: ModelOption.self, database: .psql)

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
	
	migrations.add(migration: AdminUser.self, database: .psql)
	
	migrations.add(migration: AddModelSetToBuilder.self, database: .psql)

    services.register(migrations)
	
	
//	BuilderHomeSet.defaultDatabase = DatabaseIdentifier<PostgreSQLDatabase>.psql
	
	BuilderHomeSet.defaultDatabase = .psql

	config.prefer(LeafRenderer.self, for: ViewRenderer.self)

	// Add command line configuration service
	//
	var commandConfig = CommandConfig.default()

	commandConfig.useFluentCommands()

	services.register(commandConfig)
	
	
}
