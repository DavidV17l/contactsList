import UIKit

protocol ContactsBusinessLogic {
    func displayTable()
    var contacts: ContactList? { get set }
    var contactsList: [Contact] { get set }
}

protocol ContactsDataStore {}

class ContactsInteractor: ContactsBusinessLogic, ContactsDataStore {
    weak var viewController: ContactsDisplayLogic?
    
    var contacts: ContactList?
    var contactsList: [Contact]
    
    init (viewController: ContactsDisplayLogic?) {
        self.viewController = viewController
        self.contactsList = []
        self.initializer()
    }
    
    internal func initializer() {
        let friends = [
            Contact(name: "Bob", email: "Bob@gmail.com", number: "349000000", section: ContactSection.friends),
            Contact(name: "Tom", email: "Tom@myspace.com", number: "349000001", section: ContactSection.friends)
        ]
        let colleagues = [
            Contact(name: "Mason", email: "tim@something.com", number: "349000004", section: ContactSection.colleagues),
            Contact(name: "Tim", email: "mason@something.com", number: "349000005", section: ContactSection.colleagues)
        ]
        let family = [
            Contact(name: "Mom", email: "mom@aol.com", number: "349000002", section: ContactSection.family),
            Contact(name: "Dad", email: "dad@aol.com", number: "349000003", section: ContactSection.family)
        ]
        
        contacts = ContactList(friends: friends, colleagues: colleagues, family: family)
        
        contactsList.append(contentsOf: friends)
        contactsList.append(contentsOf: colleagues)
        contactsList.append(contentsOf: family)
    }
    
    internal func displayTable(){
        guard let contactsUpdateList = contacts else { return }
        viewController?.update(with: contactsUpdateList, animate: true)
    }
}

