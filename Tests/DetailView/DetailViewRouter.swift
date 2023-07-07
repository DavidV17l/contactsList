import UIKit

@objc protocol IDetailViewRoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

protocol IDetailViewDataPassing {
    var dataStore: IDetailViewDataStore? { get }
}

class DetailViewRouter: NSObject, IDetailViewRoutingLogic, IDetailViewDataPassing {
    weak var viewController: DetailViewController?
    var dataStore: IDetailViewDataStore?

    init(viewController: DetailViewController?, dataStore: IDetailViewDataStore?) {
        self.viewController = viewController
        self.dataStore = dataStore
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }    
}
