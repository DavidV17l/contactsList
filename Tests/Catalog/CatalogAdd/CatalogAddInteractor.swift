import UIKit

protocol ICatalogAddBusinessLogic {
}

protocol ICatalogAddDataStore {}

class CatalogAddInteractor: ICatalogAddBusinessLogic, ICatalogAddDataStore {
    weak var viewController: ICatalogAddDisplayLogic?

    init (viewController: ICatalogAddDisplayLogic?) {
        self.viewController = viewController
    }
}
