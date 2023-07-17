import UIKit

enum CatalogSection: String, CaseIterable {
    case everything = "everything"
}

class Object: NSObject {
    var title: String
    var picture: UIImage?
    var detail1: String?
    var detail2: String?
    var desc1: String?
    var desc2: String?
    
    init(title: String, picture: UIImage?, detail1: String?, detail2: String?, desc1: String?, desc2: String?) {
        self.title = title
        self.picture = picture
        self.detail1 = detail1
        self.detail2 = detail2
        self.desc1 = desc1
        self.desc2 = desc2
    }
}

struct ObjectList {
    var everything: [Object]
}
