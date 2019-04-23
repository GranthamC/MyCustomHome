import Vapor
import Fluent


/// Register your application's routes here.
public func routes(_ router: Router) throws {
	
	
	// Register the model route controllers
	//
	let userController = UserController()
	
	try router.register(collection: userController)
	
	
	let homebuilderController = HomeBuilderController()

	try router.register(collection: homebuilderController)

	
	let productLineController = ProductLineController()
	
	try router.register(collection: productLineController)

	
	let imageAssetController = ImageAssetController()
	
	try router.register(collection: imageAssetController)

	
	let builderOptionCategoryController = BuilderCategoryController()
	
	try router.register(collection: builderOptionCategoryController)
	
	
	let builderOptionItemController = BuilderOptionController()
	
	try router.register(collection: builderOptionItemController)
	
	
	let decorOptionCategoryController = DecorOptionCategoryController()
	
	try router.register(collection: decorOptionCategoryController)
	
	
	let decorOptionItemController = DecorItemController()
	
	try router.register(collection: decorOptionItemController)

	
	let homeModelController = HomeModelController()
	
	try router.register(collection: homeModelController)
	
	
	let decorPackageController = DecorPackageController()
	
	try router.register(collection: decorPackageController)
	
	
	let tokensPackageController = ChangeTokenController()
	
	try router.register(collection: tokensPackageController)
	
	
	let modelOptionsPackageController = ModelOptionController()
	
	try router.register(collection: modelOptionsPackageController)
	
	
	let modelOptionCategoryPackageController = ModelOptionCategoryController()
	
	try router.register(collection: modelOptionCategoryPackageController)

	
	let homeSetsPackageController = HomeSetController()
	
	try router.register(collection: homeSetsPackageController)
	
	
	let setCategoryPackageController = SetCategoryController()
	
	try router.register(collection: setCategoryPackageController)
	
	
	let lineDecorCategoryPackageController = LineDecorCategoryController()
	
	try router.register(collection: lineDecorCategoryPackageController)
	
	
	let modelDecorCategoryPackageController = ModelDecorCategoryController()
	
	try router.register(collection: modelDecorCategoryPackageController)
	
	
	let modelBuilderCategoryPackageController = ModelBuilderCategoryController()
	
	try router.register(collection: modelBuilderCategoryPackageController)
	
	
	let lineBuilderCategoryPackageController = PL_BdrOptionCategoryController()
	
	try router.register(collection: lineBuilderCategoryPackageController)

	
	let decorMediaPackageController = DecorMediaController()
	
	try router.register(collection: decorMediaPackageController)
	
	
	let lineSeriesPackageController = ProductSeriesController()
	
	try router.register(collection: lineSeriesPackageController)

	
	let websiteController = WebsiteController()
	try router.register(collection: websiteController)
	
	
}
