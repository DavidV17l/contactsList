import UIKit

protocol IEurekaBusinessLogic {}

protocol IEurekaDataStore {}

class EurekaInteractor: IEurekaBusinessLogic, IEurekaDataStore {
    weak var viewController: IEurekaDisplayLogic?

    init (viewController: IEurekaDisplayLogic?) {
        self.viewController = viewController
    }
}
