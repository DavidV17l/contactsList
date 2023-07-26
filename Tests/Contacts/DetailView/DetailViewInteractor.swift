import UIKit

protocol IDetailViewBusinessLogic {}

protocol IDetailViewDataStore {}

class DetailViewInteractor: IDetailViewBusinessLogic, IDetailViewDataStore {
    weak var viewController: IDetailViewDisplayLogic?

    init (viewController: IDetailViewDisplayLogic?) {
        self.viewController = viewController
    }
}
