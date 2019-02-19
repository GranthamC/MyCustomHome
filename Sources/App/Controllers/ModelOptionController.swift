
import Vapor
import Fluent
import Authentication



struct ModelOptionController: RouteCollection
{
	
	func boot(router: Router) throws {
		
		let modelOptionItemsRoute = router.grouped("api", "model-option")
		
		modelOptionItemsRoute.get(use: getAllHandler)
		
		modelOptionItemsRoute.get(ModelOption.parameter, use: getHandler)
		
		modelOptionItemsRoute.get(ModelOption.parameter, "home-model", use: getHomeModelHandler)
		
		// Add-in authentication for creating and updating
		//
		let tokenAuthMiddleware = User.tokenAuthMiddleware()
		let guardAuthMiddleware = User.guardAuthMiddleware()
		
		let tokenAuthGroup = modelOptionItemsRoute.grouped(
			tokenAuthMiddleware,
			guardAuthMiddleware)
		
		tokenAuthGroup.post(ModelOption.self, use: createHandler)
		
		tokenAuthGroup.delete(ModelOption.parameter, use: deleteHandler)
		
		tokenAuthGroup.put(ModelOption.parameter, use: updateHandler)
		
	}
	
	
	func createHandler(_ req: Request, modelOptionItem: ModelOption) throws -> Future<ModelOption> {
		
		return modelOptionItem.save(on: req)
	}
	
	
	func getAllHandler(_ req: Request) throws -> Future<[ModelOption]>
	{
		return ModelOption.query(on: req).all()
	}
	
	
	func getHandler(_ req: Request) throws -> Future<ModelOption>
	{
		return try req.parameters.next(ModelOption.self)
	}
	
	
	// Update passed product model option Item with parameters
	//
	func updateHandler(_ req: Request) throws -> Future<ModelOption> {
		
		return try flatMap(
			to: ModelOption.self,
			req.parameters.next(ModelOption.self),
			req.content.decode(ModelOption.self)
		) { optionItem, updatedItem in
			
			optionItem.name = updatedItem.name
			optionItem.modelID = updatedItem.modelID
			optionItem.optionType = updatedItem.optionType
			optionItem.changeToken = updatedItem.changeToken
			
			optionItem.optionImageURL = updatedItem.optionImageURL
			optionItem.optionModelURL = updatedItem.optionModelURL
			optionItem.optionTexCoordsURL = updatedItem.optionTexCoordsURL
			optionItem.detailInfo = updatedItem.detailInfo
			optionItem.optionColor = updatedItem.optionColor
			optionItem.isUpgrade = updatedItem.isUpgrade
			optionItem.imageScale = updatedItem.imageScale
			optionItem.physicalWidth = updatedItem.physicalWidth
			optionItem.physicalHeight = updatedItem.physicalHeight
			
			return optionItem.save(on: req)
		}
	}
	
	
	func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
		
		return try req.parameters.next(ModelOption.self).delete(on: req).transform(to: HTTPStatus.noContent)
	}
	
	
	// Get the Builder record for this model option Item
	//
	func getHomeModelHandler(_ req: Request) throws -> Future<HomeModel> {
		
		return try req.parameters.next(ModelOption.self).flatMap(to: HomeModel.self) { modelOptionItem in
			
			modelOptionItem.homeModel.get(on: req)
		}
	}
	
	
}





