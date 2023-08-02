import UIKit

@objc protocol IVC1RoutingLogic {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
    func routeToVC2()
    func routeToVC3()
    func routeToVC4()
    func routeToCatalog()
    func routeToClient()
    func routeToEureka()
}

protocol IVC1DataPassing {
    var dataStore: IVC1DataStore? { get }
}

class VC1Router: NSObject, IVC1RoutingLogic, IVC1DataPassing {
    weak var viewController: VC1ViewController?
    var dataStore: IVC1DataStore?
    
    init(viewController: VC1ViewController?, dataStore: IVC1DataStore?) {
        self.viewController = viewController
        self.dataStore = dataStore
    }

    // MARK: Routing

    func routeToVC2() {
        viewController?.performSegue(withIdentifier: "exchangeSegue", sender: nil)
    }
    
    func routeToVC3() {
        viewController?.performSegue(withIdentifier: "tableViewSegue", sender: nil)
    }
    
    func routeToVC4() {
        viewController?.performSegue(withIdentifier: "tableViewSegue2", sender: nil)
    }
    
    func routeToCatalog() {
        viewController?.performSegue(withIdentifier: "routeToCatalogSegue", sender: nil)
    }
    
    func routeToClient() {
        viewController?.performSegue(withIdentifier: "clientSegue", sender: nil)
    }
    
    func routeToEureka() {
        viewController?.performSegue(withIdentifier: "toEurekaSegue", sender: nil)
    }
    
    // MARK: Navigation

    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exchangeSegue" {
            guard let viewDestination = segue.destination as? VC2ViewController,
                  var destinationDS = viewDestination.router?.dataStore else {
                return
            }
            destinationDS.name = dataStore?.name ?? ""
        }
        else if segue.identifier == "tableViewSegue" {
            guard let viewDestination = segue.destination as? VC3ViewController,
                  let _ = viewDestination.router?.dataStore else {
                return
            }
        }
    }  
}
