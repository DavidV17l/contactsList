import UIKit

protocol ICatalogDetailBusinessLogic {}

protocol ICatalogDetailDataStore {}

class CatalogDetailInteractor: ICatalogDetailBusinessLogic, ICatalogDetailDataStore {
    weak var viewController: ICatalogDetailDisplayLogic?

    init (viewController: ICatalogDetailDisplayLogic?) {
        self.viewController = viewController
    }
}
