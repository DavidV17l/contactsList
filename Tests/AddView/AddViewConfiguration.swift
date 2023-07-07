import Foundation
import Swinject
import SwinjectAutoregistration

class AddViewAssembly: Assembly {

    public func assemble(container: Container) {

        container.autoregister(IAddViewBusinessLogic.self, 
						        argument: IAddViewDisplayLogic.self, 
						        initializer: AddViewInteractor.init)
        container.autoregister(IAddViewRoutingLogic.self, 
						        arguments: AddViewController.self, IAddViewDataStore.self,
						        initializer: AddViewRouter.init)

    }
}

class AddViewConfigurator {
    class func setup(container: Container) {

        container.storyboardInitCompleted(AddViewController.self) { _, controller in
            let resolver = assembler.resolver
            let businessLogic = resolver.resolve(IAddViewBusinessLogic.self, 
									            argument: controller as IAddViewDisplayLogic)
            let routingLogic = resolver.resolve(IAddViewRoutingLogic.self, 
            									arguments: controller, businessLogic as! IAddViewDataStore)

            controller.interactor = businessLogic
            controller.router = routingLogic as? (NSObjectProtocol & IAddViewDataPassing & IAddViewRoutingLogic)
        }
    }
}
