import UIKit

protocol IAddViewBusinessLogic {}

protocol IAddViewDataStore {}

class AddViewInteractor: IAddViewBusinessLogic, IAddViewDataStore {
    weak var viewController: IAddViewDisplayLogic?

    init (viewController: IAddViewDisplayLogic?) {
        self.viewController = viewController
    }
}
