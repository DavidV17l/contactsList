import Foundation
import Swinject
import SwinjectAutoregistration

class CatalogAssembly: Assembly {

    public func assemble(container: Container) {

        container.autoregister(ICatalogBusinessLogic.self, 
						        argument: ICatalogDisplayLogic.self, 
						        initializer: CatalogInteractor.init)
        container.autoregister(ICatalogRoutingLogic.self, 
						        arguments: CatalogViewController.self, ICatalogDataStore.self, 
						        initializer: CatalogRouter.init)

    }
}

class CatalogConfigurator {
    class func setup(container: Container) {

        container.storyboardInitCompleted(CatalogViewController.self) { _, controller in
            let resolver = assembler.resolver
            let businessLogic = resolver.resolve(ICatalogBusinessLogic.self, 
									            argument: controller as ICatalogDisplayLogic)
            let routingLogic = resolver.resolve(ICatalogRoutingLogic.self, 
            									arguments: controller, businessLogic as! ICatalogDataStore)

            controller.interactor = businessLogic
            controller.router = routingLogic as? (NSObjectProtocol & ICatalogDataPassing & ICatalogRoutingLogic)
        }
    }
}
