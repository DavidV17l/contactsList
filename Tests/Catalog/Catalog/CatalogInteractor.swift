import UIKit
import FirebaseFirestore

protocol ICatalogBusinessLogic {
    var objects: ObjectList? { get set }
    var objectList: [Object] { get set }
    func displayView()
    func initializer()
}

protocol ICatalogDataStore {
    var selectedItem: Object? { get set }
}

class CatalogInteractor: ICatalogBusinessLogic, ICatalogDataStore {
    
    weak var viewController: ICatalogDisplayLogic?
    
    let db = Firestore.firestore()
    
    var objects: ObjectList?
    var objectList: [Object]
    internal var selectedItem: Object?
    
    init (viewController: ICatalogDisplayLogic?) {
        self.viewController = viewController
        self.objectList = []
    }
    
    internal func displayView(){
        viewController?.update(with: objectList, animate: true)
    }
    
    internal func initializer() {
        var objectArray: [Object] = []
        db.collection("objects").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    let picture = data["picture"] as? String
                    let detail1 = data["detail1"] as? String
                    let detail2 = data["detail2"] as? String
                    let desc1 = data["desc1"] as? String
                    let desc2 = data["desc2"] as? String
                    let object = Object(id: id, title: title, picture: picture, detail1: detail1, detail2: detail2, desc1: desc1, desc2: desc2)
                    objectArray.append(object)
                }
                self.objects = ObjectList(everything: objectArray)
                self.objectList.append(contentsOf: objectArray)
                self.viewController?.catalogList = self.objectList
                self.viewController?.update(with: self.objectList, animate: true)
            }
        }
    }
}
