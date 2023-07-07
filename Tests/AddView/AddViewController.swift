import UIKit

protocol IAddViewDisplayLogic: AnyObject {}

class AddViewController: UIViewController, IAddViewDisplayLogic, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - Variables
    var interactor: IAddViewBusinessLogic?
    var router: (NSObjectProtocol & IAddViewRoutingLogic & IAddViewDataPassing)?
    var viewController: ContactsViewController?
    
    var name: String = ""
    var email: String = ""
    var number: String = ""
    var section: String = ""
    
    var selectedContact: Contact!
    var editMode: Bool = false
    
    var callback: (([String]) -> ())?
    
    @IBOutlet weak var tableForm: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    // MARK: - Iniatializers
    override func viewDidLoad() {
        super.viewDidLoad()
        tableForm.register(AddCell.nib, forCellReuseIdentifier: AddCell.identifier)
        tableForm.delegate = self
        tableForm.dataSource = self
    }
    
    // MARK: - Logic
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if editMode == true {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AddCell.identifier) as? AddCell {
                switch indexPath.row {
                case 0: cell.textField.text = selectedContact.name
                case 1: cell.textField.text = selectedContact.email
                case 2: cell.textField.text = selectedContact.number
                case 3: cell.textField.text = "\(selectedContact.section)"
                default: cell.textField.placeholder = "Error -.-"
                }
                
                cell.textField.tag = indexPath.row
                cell.textField.delegate = self
                
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: AddCell.identifier) as? AddCell
            {
                switch indexPath.row {
                case 0: cell.textField.placeholder = "Full name"
                case 1: cell.textField.placeholder = "Email address"
                case 2: cell.textField.placeholder = "Number"
                case 3: cell.textField.placeholder = "Section"
                default: cell.textField.placeholder = "Error -.-"
                }
                
                cell.textField.tag = indexPath.row
                cell.textField.delegate = self
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if editMode == true {
            viewController?.editedContact = Contact(name: name, email: email, number: number, section: Section(rawValue: section)!)
        } else {
            callback?([name, email, number, section])
        }
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    @objc func valueChanged(_ textField: UITextField){
        
        switch textField.tag {
        case 0:
            name = textField.text!
        case 1:
            email = textField.text!
        case 2:
            number = textField.text!
        case 3:
            section = textField.text!
        default:
            break
        }
    }
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }
}
