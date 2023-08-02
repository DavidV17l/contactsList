import UIKit
import Eureka

protocol IEurekaDisplayLogic: AnyObject {}

class EurekaViewController: UIViewController, IEurekaDisplayLogic {
    
    //MARK: - Variables
    var interactor: IEurekaBusinessLogic?
    var router: (NSObjectProtocol & IEurekaRoutingLogic & IEurekaDataPassing)?
    
    var form: Form = Form()
    
    //MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Section1")
        <<< TextRow(){ row in
            row.title = "Text Row"
            row.placeholder = "Enter text here"
        }
        <<< PhoneRow(){
            $0.title = "Phone Row"
            $0.placeholder = "And numbers here"
        }
        +++ Section("Section2")
        <<< DateRow(){
            $0.title = "Date Row"
            $0.value = Date(timeIntervalSinceReferenceDate: 0)
        }
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }
}
