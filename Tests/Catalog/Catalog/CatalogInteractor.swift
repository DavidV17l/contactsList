import UIKit

protocol ICatalogBusinessLogic {
    var objects: ObjectList? { get set }
    var objectList: [Object] { get set }
    func displayView()
}

protocol ICatalogDataStore {}

class CatalogInteractor: ICatalogBusinessLogic, ICatalogDataStore {
    
    weak var viewController: ICatalogDisplayLogic?
    
    var objects: ObjectList?
    var objectList: [Object]
    
    init (viewController: ICatalogDisplayLogic?) {
        self.viewController = viewController
        self.objectList = []
        self.initializer()
    }
    
    internal func initializer() {
        let objectsArray = [
            Object(title: "Austria", picture: UIImage(named: "at"), detail1: "Vienna", detail2: "9 million", desc1: "Capitol City", desc2: "Population"),
            Object(title: "Belgium", picture: UIImage(named: "be"), detail1: "Brussels", detail2: "12 million", desc1: "Capitol City", desc2: "Population"),
            Object(title: "Germany", picture: UIImage(named: "de"), detail1: "Berlin", detail2: "83 million", desc1: "Capitol City", desc2: "Population"),
            Object(title: "Greece", picture: UIImage(named: "el"), detail1: "Athens", detail2: "10.5 million", desc1: "Capitol City", desc2: "Population"),
            Object(title: "France", picture: UIImage(named: "fr"), detail1: "Paris", detail2: "68 million", desc1: "Capitol City", desc2: "Population")
        ]
        
        objects = ObjectList(everything: objectsArray)
        objectList.append(contentsOf: objectsArray)
    }
    
    internal func displayView(){
        guard let objectUpdateList = objects else { return }
        viewController?.update(with: objectUpdateList, animate: true)
    }
}
