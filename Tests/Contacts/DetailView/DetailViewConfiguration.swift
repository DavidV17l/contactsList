import Foundation
import Swinject
import SwinjectAutoregistration

class DetailViewAssembly: Assembly {

    public func assemble(container: Container) {

        container.autoregister(IDetailViewBusinessLogic.self, 
						        argument: IDetailViewDisplayLogic.self, 
						        initializer: DetailViewInteractor.init)
        container.autoregister(IDetailViewRoutingLogic.self, 
						        arguments: DetailViewController.self, IDetailViewDataStore.self,
						        initializer: DetailViewRouter.init)

    }
}

class DetailViewConfigurator {
    class func setup(container: Container) {

        container.storyboardInitCompleted(DetailViewController.self) { _, controller in
            let resolver = assembler.resolver
            let businessLogic = resolver.resolve(IDetailViewBusinessLogic.self, 
									            argument: controller as IDetailViewDisplayLogic)
            let routingLogic = resolver.resolve(IDetailViewRoutingLogic.self, 
            									arguments: controller, businessLogic as! IDetailViewDataStore)

            controller.interactor = businessLogic
            controller.router = routingLogic as? (NSObjectProtocol & IDetailViewDataPassing & IDetailViewRoutingLogic)
        }
    }
}
