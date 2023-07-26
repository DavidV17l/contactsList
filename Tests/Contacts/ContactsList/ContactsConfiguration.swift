import Foundation
import Swinject
import SwinjectAutoregistration

class ContactsAssembly: Assembly {

    public func assemble(container: Container) {

        container.autoregister(ContactsBusinessLogic.self,
						        argument: ContactsDisplayLogic.self,
						        initializer: ContactsInteractor.init)
        container.autoregister(ContactsRoutingLogic.self,
						        arguments: ContactsViewController.self, ContactsDataStore.self,
						        initializer: ContactsRouter.init)

    }
}

class ContactsConfigurator {
    class func setup(container: Container) {

        container.storyboardInitCompleted(ContactsViewController.self) { _, controller in
            let resolver = assembler.resolver
            let businessLogic = resolver.resolve(ContactsBusinessLogic.self,
									            argument: controller as ContactsDisplayLogic)
            let routingLogic = resolver.resolve(ContactsRoutingLogic.self,
            									arguments: controller, businessLogic as! ContactsDataStore)

            controller.interactor = businessLogic
            controller.router = routingLogic as? (NSObjectProtocol & ContactsDataPassing & ContactsRoutingLogic)
        }
    }
}
