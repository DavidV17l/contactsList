import Foundation
import Swinject
import SwinjectAutoregistration

class ClientAssembly: Assembly {

    public func assemble(container: Container) {

        container.autoregister(IClientBusinessLogic.self, 
						        argument: IClientDisplayLogic.self, 
						        initializer: ClientInteractor.init)
        container.autoregister(IClientRoutingLogic.self, 
						        arguments: ClientViewController.self, IClientDataStore.self, 
						        initializer: ClientRouter.init)

    }
}

class ClientConfigurator {
    class func setup(container: Container) {

        container.storyboardInitCompleted(ClientViewController.self) { _, controller in
            let resolver = assembler.resolver
            let businessLogic = resolver.resolve(IClientBusinessLogic.self, 
									            argument: controller as IClientDisplayLogic)
            let routingLogic = resolver.resolve(IClientRoutingLogic.self, 
            									arguments: controller, businessLogic as! IClientDataStore)

            controller.interactor = businessLogic
            controller.router = routingLogic as? (NSObjectProtocol & IClientDataPassing & IClientRoutingLogic)
        }
    }
}
