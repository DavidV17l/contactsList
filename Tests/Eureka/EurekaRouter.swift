import UIKit

@objc protocol IEurekaRoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

protocol IEurekaDataPassing {
    var dataStore: IEurekaDataStore? { get }
}

class EurekaRouter: NSObject, IEurekaRoutingLogic, IEurekaDataPassing {
    weak var viewController: EurekaViewController?
    var dataStore: IEurekaDataStore?

    init(viewController: EurekaViewController?, dataStore: IEurekaDataStore?) {
        self.viewController = viewController
        self.dataStore = dataStore
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {}    
}
