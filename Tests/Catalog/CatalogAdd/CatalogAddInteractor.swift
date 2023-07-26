import UIKit

protocol ICatalogAddBusinessLogic {}

protocol ICatalogAddDataStore {
    var vc: ICatalogDisplayLogic? { get set }
    var detailVC: ICatalogDetailDisplayLogic? { get set }
    var item: Object? { get set }
}

class CatalogAddInteractor: ICatalogAddBusinessLogic, ICatalogAddDataStore {
    weak var viewController: ICatalogAddDisplayLogic?
    
    var vc: ICatalogDisplayLogic?
    var detailVC: ICatalogDetailDisplayLogic?
    var item: Object?

    init (viewController: ICatalogAddDisplayLogic?) {
        self.viewController = viewController
    }
}
