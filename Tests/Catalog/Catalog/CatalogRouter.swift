import UIKit

@objc protocol ICatalogRoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func routeToDetail()
    func routeToAdd()
}

protocol ICatalogDataPassing {
    var dataStore: ICatalogDataStore? { get }
}

class CatalogRouter: NSObject, ICatalogRoutingLogic, ICatalogDataPassing {
    weak var viewController: CatalogViewController?
    var dataStore: ICatalogDataStore?

    init(viewController: CatalogViewController?, dataStore: ICatalogDataStore?) {
        self.viewController = viewController
        self.dataStore = dataStore
    }
    
    func routeToDetail() {
        viewController?.performSegue(withIdentifier: "handleDetailCatalogSegue", sender: self)
    }
    
    func routeToAdd() {
        viewController?.performSegue(withIdentifier: "handleAddCatalogSegue", sender: self)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "handleAddCatalogSegue" {
            guard let vc = segue.destination as? CatalogAddViewController, var ds = vc.router?.dataStore else { return }
            ds.vc = self.viewController
        }
        else if segue.identifier == "handleDetailCatalogSegue" {
            guard let vc = segue.destination as? CatalogDetailViewController, var ds = vc.router?.dataStore else { return }
            ds.vc = self.viewController
        }
        handleDetailSegue(segue: segue)
    }
    
    func handleDetailSegue(segue: UIStoryboardSegue) {
        let catalogDetail = segue.destination as? CatalogDetailViewController
        catalogDetail?.selectedItem = dataStore?.selectedItem
    }
}
