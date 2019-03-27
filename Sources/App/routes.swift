import Vapor
import Fluent


/// Register your application's routes here.
public func routes(_ router: Router) throws {
	
/*
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    
    router.post("api", "MyCustomHome") { req -> Future<MyCustomHome> in
        return try req.content.decode(MyCustomHome.self)
            .flatMap(to: MyCustomHome.self) { MyCustomHome in
                
                return MyCustomHome.save(on: req)
        }
    }
    

    router.get("api", "MyCustomHome") { req -> Future<[MyCustomHome]> in

        return MyCustomHome.query(on: req).all()
    }
	
	
	router.get("api", "MyCustomHome", MyCustomHome.parameter)
	{
		req -> Future<MyCustomHome> in

		return try req.parameters.next(MyCustomHome.self)
	}
	
	
	router.put("api", "MyCustomHome", MyCustomHome.parameter)
	{
		req -> Future<MyCustomHome> in
		
		return try flatMap(to: MyCustomHome.self, req.parameters.next(MyCustomHome.self), req.content.decode(MyCustomHome.self)) {	record, updatedRecord in
			
			record.short = updatedRecord.short
			record.long = updatedRecord.long
			
			return record.save(on: req)
		}
	}
	
	
	router.delete("api", "MyCustomHome", MyCustomHome.parameter)
	{
		req -> Future<HTTPStatus> in

		return try req.parameters.next(MyCustomHome.self)

			.delete(on: req)

			.transform(to: HTTPStatus.noContent)
	}
	
	
	router.get("api", "MyCustomHome", "search")
	{
		req -> Future<[MyCustomHome]> in
		
		guard let searchTerm = req.query[String.self, at: "term"] else
		{
			throw Abort(.badRequest)
		}
		
		return MyCustomHome.query(on: req).group(.or) { or in
 
			or.filter(\.short == searchTerm)
 
			or.filter(\.long == searchTerm)}.all()
	}

	
	router.get("api", "MyCustomHome", "first")
	{
		req -> Future<MyCustomHome> in
		
		return MyCustomHome.query(on: req)
			.first()
			.map(to: MyCustomHome.self) { record in
				
				guard let record = record else {
					throw Abort(.notFound)
				}
				
				return record
		}
	}

	
	router.get("api", "MyCustomHome", "sorted")
	{
		req -> Future<[MyCustomHome]> in
 
		return MyCustomHome.query(on: req) .sort(\.short, .ascending) .all()
	}
*/
	
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

	
	let websiteController = WebsiteController()
	try router.register(collection: websiteController)
	
	
}
