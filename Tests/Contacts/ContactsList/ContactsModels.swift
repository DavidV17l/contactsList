import UIKit

enum ContactSection: String, CaseIterable {
    case friends = "friends"
    case colleagues = "colleagues"
    case family = "family"
    
    static func withLabel(_ label: String) -> ContactSection? {
        return self.allCases.first{ "\($0)" == label }
    }
}

class Contact: NSObject {
    var name: String
    var email: String
    var number: String
    var section: ContactSection
    var profileImage: UIImage?
    
    init(name: String, email: String, number: String, section: ContactSection) {
        self.name = name
        self.email = email
        self.number = number
        self.section = section
    }
}

struct ContactList {
    var friends: [Contact]
    var colleagues: [Contact]
    var family: [Contact]
}
