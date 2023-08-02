import UIKit

@objc protocol IClientRoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

protocol IClientDataPassing {
    var dataStore: IClientDataStore? { get }
}

class ClientRouter: NSObject, IClientRoutingLogic, IClientDataPassing {
    weak var viewController: ClientViewController?
    var dataStore: IClientDataStore?

    init(viewController: ClientViewController?, dataStore: IClientDataStore?) {
        self.viewController = viewController
        self.dataStore = dataStore
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }    
}
