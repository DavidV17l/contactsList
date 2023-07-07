//
//  VC3Configuration.swift
//  Tests
//
//  Created by davide on 28/06/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation
import Swinject
import SwinjectAutoregistration

class VC3Assembly: Assembly {

    public func assemble(container: Container) {

        container.autoregister(IVC3BusinessLogic.self, 
						        argument: IVC3DisplayLogic.self, 
						        initializer: VC3Interactor.init)
        container.autoregister(IVC3RoutingLogic.self, 
						        arguments: VC3ViewController.self, IVC3DataStore.self, 
						        initializer: VC3Router.init)

    }
}

class VC3Configurator {
    class func setup(container: Container) {

        container.storyboardInitCompleted(VC3ViewController.self) { _, controller in
            let resolver = assembler.resolver
            let businessLogic = resolver.resolve(IVC3BusinessLogic.self, 
									            argument: controller as IVC3DisplayLogic)
            let routingLogic = resolver.resolve(IVC3RoutingLogic.self, 
            									arguments: controller, businessLogic as! IVC3DataStore)

            controller.interactor = businessLogic
            controller.router = routingLogic as? (NSObjectProtocol & IVC3DataPassing & IVC3RoutingLogic)
        }
    }
}
