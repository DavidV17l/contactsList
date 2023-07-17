import UIKit

@objc protocol ICatalogRoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func routeToDetail()
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
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        handleDetailSegue(segue: segue)
    }
    
    func handleDetailSegue(segue: UIStoryboardSegue) {
        let catalogDetail = segue.destination as? CatalogDetailViewController
        guard let index = viewController?.selectedPath else { return }
        guard let items = viewController?.catalogList else { return }
        let selectedItem: Object = items[index.item]
        catalogDetail?.selectedItem = selectedItem
    }
}
