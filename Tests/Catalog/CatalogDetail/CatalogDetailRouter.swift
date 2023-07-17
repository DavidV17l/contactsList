import UIKit

@objc protocol ICatalogDetailRoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

protocol ICatalogDetailDataPassing {
    var dataStore: ICatalogDetailDataStore? { get }
}

class CatalogDetailRouter: NSObject, ICatalogDetailRoutingLogic, ICatalogDetailDataPassing {
    weak var viewController: CatalogDetailViewController?
    var dataStore: ICatalogDetailDataStore?

    init(viewController: CatalogDetailViewController?, dataStore: ICatalogDetailDataStore?) {
        self.viewController = viewController
        self.dataStore = dataStore
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
}
