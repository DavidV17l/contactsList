import Foundation
import Swinject
import SwinjectAutoregistration

class EurekaAssembly: Assembly {

    public func assemble(container: Container) {

        container.autoregister(IEurekaBusinessLogic.self, 
						        argument: IEurekaDisplayLogic.self, 
						        initializer: EurekaInteractor.init)
        container.autoregister(IEurekaRoutingLogic.self, 
						        arguments: EurekaViewController.self, IEurekaDataStore.self, 
						        initializer: EurekaRouter.init)

    }
}

class EurekaConfigurator {
    class func setup(container: Container) {

        container.storyboardInitCompleted(EurekaViewController.self) { _, controller in
            let resolver = assembler.resolver
            let businessLogic = resolver.resolve(IEurekaBusinessLogic.self, 
									            argument: controller as IEurekaDisplayLogic)
            let routingLogic = resolver.resolve(IEurekaRoutingLogic.self, 
            									arguments: controller, businessLogic as! IEurekaDataStore)

            controller.interactor = businessLogic
            controller.router = routingLogic as? (NSObjectProtocol & IEurekaDataPassing & IEurekaRoutingLogic)
        }
    }
}
