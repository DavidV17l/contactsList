import UIKit

protocol ICatalogDetailBusinessLogic {}

protocol ICatalogDetailDataStore {
    var vc: ICatalogDisplayLogic? { get set }
}

class CatalogDetailInteractor: ICatalogDetailBusinessLogic, ICatalogDetailDataStore {
    weak var viewController: ICatalogDetailDisplayLogic?
    
    var vc: ICatalogDisplayLogic?

    init (viewController: ICatalogDetailDisplayLogic?) {
        self.viewController = viewController
    }
}
