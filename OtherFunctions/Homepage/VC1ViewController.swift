import UIKit

protocol IVC1DisplayLogic: AnyObject {
    func routeTo()
    func routeToTableView()
    func routeToTableView2()
    func routeToCatalog()
    func routeToClient()
    func routeToEureka()
}

class VC1ViewController: UIViewController, IVC1DisplayLogic {
    var interactor: IVC1BusinessLogic?
    var router: (NSObjectProtocol & IVC1RoutingLogic & IVC1DataPassing)?

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func buttonPressed(_ sender: Any) {
        updateText()
    }
    
    @IBAction func buttonTableViewPressed(_ sender: Any) {
        interactor?.displayTableView()
    }
    
    @IBAction func buttonTableView2Pressed(_ sender: Any) {
        interactor?.displayTableView2()
    }
    
    @IBAction func catalogButtonpressed(_ sender: Any) {
        interactor?.displayCatalog()
    }
    
    @IBAction func clientButtonPressed(_ sender: Any) {
        interactor?.displayClient()
    }
    
    @IBAction func eurekaButtonPressed(_ sender: Any) {
        interactor?.displayEureka()
    }
    
    func routeTo() {
        router?.routeToVC2()
    }
    
    func routeToTableView() {
        router?.routeToVC3()
    }
    
    func routeToTableView2() {
        router?.routeToVC4()
    }
    
    func routeToCatalog() {
        router?.routeToCatalog()
    }
    
    func routeToClient() {
        router?.routeToClient()
    }
    
    func routeToEureka() {
        router?.routeToEureka()
    }
    
    func updateText() {
        let name = textField.text!
        let request = VC1Models.ShowText.Request(name: name)
        interactor?.displayText(request: request)
    }
    
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
