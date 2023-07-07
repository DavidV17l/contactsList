import UIKit

protocol ContactsBusinessLogic {
    func displayTable() -> [Contact]
    var contacts: ContactList? { get set }
}

protocol ContactsDataStore {}

class ContactsInteractor: ContactsBusinessLogic, ContactsDataStore {
    weak var viewController: ContactsDisplayLogic?
    
    var contacts: ContactList?
    var contactsList: [Contact]
    
    init (viewController: ContactsDisplayLogic?) {
        self.viewController = viewController
        self.contacts = ContactList(friends: [], colleagues: [], family: [])
        self.contactsList = []
    }
    
    internal func displayTable() -> [Contact]{
        
        let friends = [
            Contact(name: "Bob", email: "Bob@gmail.com", number: "349000000", section: Section.friends),
            Contact(name: "Tom", email: "Tom@myspace.com", number: "349000001", section: Section.friends)
        ]
        let colleagues = [
            Contact(name: "Mason", email: "tim@something.com", number: "349000004", section: Section.colleagues),
            Contact(name: "Tim", email: "mason@something.com", number: "349000005", section: Section.colleagues)
        ]
        let family = [
            Contact(name: "Mom", email: "mom@aol.com", number: "349000002", section: Section.family),
            Contact(name: "Dad", email: "dad@aol.com", number: "349000003", section: Section.family)
        ]
        
        let contactList = ContactList(friends: friends, colleagues: colleagues, family: family)
        viewController?.update(with: contactList, animate: true)
        contacts = contactList
        contactsList.append(contentsOf: friends)
        contactsList.append(contentsOf: colleagues)
        contactsList.append(contentsOf: family)
        
        return contactsList
    }
}

