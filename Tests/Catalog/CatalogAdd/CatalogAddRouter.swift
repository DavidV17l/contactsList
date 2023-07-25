import UIKit

@objc protocol ICatalogAddRoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

protocol ICatalogAddDataPassing {
    var dataStore: ICatalogAddDataStore? { get }
}

class CatalogAddRouter: NSObject, ICatalogAddRoutingLogic, ICatalogAddDataPassing {
    weak var viewController: CatalogAddViewController?
    var dataStore: ICatalogAddDataStore?

    init(viewController: CatalogAddViewController?, dataStore: ICatalogAddDataStore?) {
        self.viewController = viewController
        self.dataStore = dataStore
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }    
}
