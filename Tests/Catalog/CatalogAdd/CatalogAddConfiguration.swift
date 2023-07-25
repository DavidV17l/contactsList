import Foundation
import Swinject
import SwinjectAutoregistration

class CatalogAddAssembly: Assembly {

    public func assemble(container: Container) {

        container.autoregister(ICatalogAddBusinessLogic.self, 
						        argument: ICatalogAddDisplayLogic.self, 
						        initializer: CatalogAddInteractor.init)
        container.autoregister(ICatalogAddRoutingLogic.self, 
						        arguments: CatalogAddViewController.self, ICatalogAddDataStore.self, 
						        initializer: CatalogAddRouter.init)

    }
}

class CatalogAddConfigurator {
    class func setup(container: Container) {

        container.storyboardInitCompleted(CatalogAddViewController.self) { _, controller in
            let resolver = assembler.resolver
            let businessLogic = resolver.resolve(ICatalogAddBusinessLogic.self, 
									            argument: controller as ICatalogAddDisplayLogic)
            let routingLogic = resolver.resolve(ICatalogAddRoutingLogic.self, 
            									arguments: controller, businessLogic as! ICatalogAddDataStore)

            controller.interactor = businessLogic
            controller.router = routingLogic as? (NSObjectProtocol & ICatalogAddDataPassing & ICatalogAddRoutingLogic)
        }
    }
}
