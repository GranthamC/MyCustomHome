import Vapor
import Fluent


/// Register your application's routes here.
public func routes(_ router: Router) throws {
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

	// Register the Builder controller
	//
	let homebuilderController = HomeBuilderController()

	try router.register(collection: homebuilderController)
	
	let productLineController = ProductLineController()
	
	try router.register(collection: productLineController)
	
	
	let builderController = BuilderController()

	try router.register(collection: builderController)
}
