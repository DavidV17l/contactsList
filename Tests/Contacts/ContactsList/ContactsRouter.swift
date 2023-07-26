import UIKit

@objc protocol ContactsRoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func routeToDetail()
    func routeToAdd()
}

protocol ContactsDataPassing {}

class ContactsRouter: NSObject, ContactsRoutingLogic, ContactsDataPassing {
    
    weak var viewController: ContactsViewController?
    
    init(viewController: ContactsViewController?, dataStore: ContactsDataStore?) {
        self.viewController = viewController
    }
    
    func routeToDetail() {
        viewController?.performSegue(withIdentifier: "handleDetailSegue", sender: self)
    }
    
    func routeToAdd() {
        viewController?.performSegue(withIdentifier: "handleAddSegue", sender: self)
    }

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "handleAddSegue" {
            self.viewController?.handleAddSegue(segue: segue)
        } else if segue.identifier == "handleDetailSegue" {
            self.viewController?.handleDetailSegue(segue: segue)
        }
    }
}
