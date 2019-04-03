
import Vapor
import Fluent
import Authentication



struct DecorMediaController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let decorOptionItemsRoute = router.grouped("api", "decor-media")
		
		decorOptionItemsRoute.get(use: getAllHandler)
		
		decorOptionItemsRoute.get(DecorMedia.parameter, use: getHandler)
		
		decorOptionItemsRoute.get(DecorMedia.parameter, "decor-item", use: getDecorItemHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = decorOptionItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(DecorMedia.self, use: createHandler)
		
		tokenAuthGroup.delete(DecorMedia.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(DecorMedia.parameter, use: updateHandler)
		
	}
	
	
	func createHandler(_ req: Request, homeOptionItem: DecorMedia) throws -> Future<DecorMedia> {
		
		return homeOptionItem.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[DecorMedia]>
	{
		return DecorMedia.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<DecorMedia>
	{
		return try req.parameters.next(DecorMedia.self)
	}
	
	
	// Update passed decor option media with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<DecorMedia> {
		
		return try flatMap(
			to: DecorMedia.self,
			req.parameters.next(DecorMedia.self),
			req.content.decode(DecorMedia.self)
		) { optionItem, updatedItem in
			
			optionItem.name = updatedItem.name
			optionItem.optionImageType = updatedItem.optionImageType
			optionItem.changeToken = updatedItem.changeToken
			
			optionItem.optionImageURL = updatedItem.optionImageURL
			optionItem.optionModelURL = updatedItem.optionModelURL
			optionItem.optionColor = updatedItem.optionColor
			optionItem.imageScale = updatedItem.imageScale
			optionItem.physicalWidth = updatedItem.physicalWidth
			optionItem.physicalHeight = updatedItem.physicalHeight
			
			return optionItem.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(DecorMedia.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the decor item record for this media Item
	//
	func getDecorItemHandler(_ req: Request) throws -> Future<DecorItem> {
		
		return try req.parameters.next(DecorMedia.self).flatMap(to: DecorItem.self) { mediaItem in
			
			mediaItem.decorItem.get(on: req)
		}
	}
	
}






