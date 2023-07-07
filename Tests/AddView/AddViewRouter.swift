import UIKit

@objc protocol IAddViewRoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

protocol IAddViewDataPassing {
    var dataStore: IAddViewDataStore? { get }
}

class AddViewRouter: NSObject, IAddViewRoutingLogic, IAddViewDataPassing {
    weak var viewController: AddViewController?
    var dataStore: IAddViewDataStore?

    init(viewController: AddViewController?, dataStore: IAddViewDataStore?) {
        self.viewController = viewController
        self.dataStore = dataStore
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }    
}
