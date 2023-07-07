//
//  SwinjectAutoregistration.swift
//  Tests
//
//  Created by davide on 27/06/23.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

var assembler: Assembler!

extension SwinjectStoryboard {
    @objc class func setup() {

        let assemblies: [Assembly] = [VC1Assembly(), VC2Assembly(), VC3Assembly(), ContactsAssembly(), DetailViewAssembly(), AddViewAssembly()]

        assembler = Assembler(assemblies)

        VC1Configurator.setup(container: defaultContainer)
        VC2Configurator.setup(container: defaultContainer)
        VC3Configurator.setup(container: defaultContainer)
        ContactsConfigurator.setup(container: defaultContainer)
        DetailViewConfigurator.setup(container: defaultContainer)
        AddViewConfigurator.setup(container: defaultContainer)
    }
}

