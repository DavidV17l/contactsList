import Foundation
import Swinject
import SwinjectAutoregistration

class CatalogDetailAssembly: Assembly {

    public func assemble(container: Container) {

        container.autoregister(ICatalogDetailBusinessLogic.self, 
						        argument: ICatalogDetailDisplayLogic.self, 
						        initializer: CatalogDetailInteractor.init)
        container.autoregister(ICatalogDetailRoutingLogic.self, 
						        arguments: CatalogDetailViewController.self, ICatalogDetailDataStore.self, 
						        initializer: CatalogDetailRouter.init)

    }
}

class CatalogDetailConfigurator {
    class func setup(container: Container) {

        container.storyboardInitCompleted(CatalogDetailViewController.self) { _, controller in
            let resolver = assembler.resolver
            let businessLogic = resolver.resolve(ICatalogDetailBusinessLogic.self, 
									            argument: controller as ICatalogDetailDisplayLogic)
            let routingLogic = resolver.resolve(ICatalogDetailRoutingLogic.self, 
            									arguments: controller, businessLogic as! ICatalogDetailDataStore)

            controller.interactor = businessLogic
            controller.router = routingLogic as? (NSObjectProtocol & ICatalogDetailDataPassing & ICatalogDetailRoutingLogic)
        }
    }
}
