import UIKit

@objc protocol ICatalogDetailRoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func routeToEdit()
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

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? CatalogAddViewController, var ds = vc.router?.dataStore else { return }
        guard let item = viewController?.selectedItem else { return }
        ds.item = item
        ds.detailVC = self.viewController
    }
    
    func routeToEdit() {
        viewController?.performSegue(withIdentifier: "handleEditSegue", sender: self)
    }
}
