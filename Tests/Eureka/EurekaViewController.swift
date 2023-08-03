import UIKit
import Eureka

protocol IEurekaDisplayLogic: AnyObject {}

class EurekaViewController: FormViewController, IEurekaDisplayLogic {
    
    //MARK: - Variables
    var interactor: IEurekaBusinessLogic?
    var router: (NSObjectProtocol & IEurekaRoutingLogic & IEurekaDataPassing)?
    
    var datas: [String] = []
    var third: Bool = false
    var custom: Bool = false
    
    //MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = .init(title: "Done", style: .plain, target: self, action: #selector(getDatas))
        form +++ Eureka.Section("Base informations")
        <<< TextRow(){
            $0.tag = "0"
            $0.title = "Title"
            $0.placeholder = "Type here..."
        }
        <<< TextRow(){
            $0.tag = "1"
            $0.title = "Image name"
            $0.placeholder = "Type here... (test)"
        }
        +++ Eureka.Section("First info")
        <<< TextRow(){
            $0.tag = "2"
            $0.title = "Description"
            $0.placeholder = "Type here..."
        }
        <<< TextRow(){
            $0.tag = "3"
            $0.title = "Specific Detail"
            $0.placeholder = "Type here..."
        }
        +++ Eureka.Section("Secondo info")
        <<< TextRow(){
            $0.tag = "4"
            $0.title = "Description"
            $0.placeholder = "Type here..."
        }
        <<< TextRow(){
            $0.tag = "5"
            $0.title = "Specific Detail"
            $0.placeholder = "Type here..."
        }
        +++ Eureka.Section("Options")
        <<< SwitchRow("switchTag"){
            $0.title = "Insert third info (optional)"
            self.third = $0.value ?? false
        }
        +++ Eureka.Section("Third info") {
            $0.hidden = Condition.function(["switchTag"], { form in
                return !((form.rowBy(tag: "switchTag") as? SwitchRow)?.value ?? false)
            })
        }
        <<< TextRow(){
            $0.tag = "6"
            $0.title = "Description"
            $0.placeholder = "Type here..."
        }
        <<< TextRow(){
            $0.tag = "7"
            $0.title = "Specific Detail"
            $0.placeholder = "Type here..."
        }
        <<< SwitchRow("switchTagCustom"){
            $0.title = "Insert custom row"
            self.custom = $0.value ?? false
        }
        +++ Eureka.Section("Custom row") {
            $0.hidden = Condition.function(["switchTagCustom"], { form in
                return !((form.rowBy(tag: "switchTagCustom") as? SwitchRow)?.value ?? false)
            })
        }
        <<< CustomRow(){
            $0.value = User(name: "Davide", email: "test@test.com", dateOfBirth: "17/03/2003")
        }
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }
    
    @objc func getDatas() {
        if third == false {
            for i in 0...5 {
                let row: TextRow? = form.rowBy(tag: "\(i)")
                guard let value = row?.value else { break }
                self.datas.append(value)
            }
        } else {
            for i in 0...7 {
                let row: TextRow? = form.rowBy(tag: "\(i)")
                guard let value = row?.value else { break }
                self.datas.append(value)
            }
        }
    }
}
