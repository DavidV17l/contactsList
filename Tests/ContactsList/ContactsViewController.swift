import UIKit

protocol ContactsDisplayLogic: AnyObject {
    var dataSource: UITableViewDiffableDataSource<Section, Contact> { get set }
    var editedContact: Contact! { get set }
    func routeToDetail()
    func routeToAdd()
    func update(with list: ContactList, animate: Bool)
    func makeDataSource() -> UITableViewDiffableDataSource<Section, Contact>
    func handleDetailSegue(segue: UIStoryboardSegue)
    func handleAddSegue(segue: UIStoryboardSegue)
}

class ContactsViewController: UIViewController, ContactsDisplayLogic, UITableViewDelegate {
    
    // MARK: - Variables
    @IBOutlet weak var contactsTableView: UITableView!
    
    var interactor: ContactsBusinessLogic?
    var router: (NSObjectProtocol & ContactsRoutingLogic & ContactsDataPassing)?
    
    private let cellReuseIdentifier = "TheCell"
    internal lazy var dataSource = makeDataSource()
    
    private var selectedPath: IndexPath?
    private var selectedSection: Section?
    private var editMode: Bool = false
    internal var editedContact: Contact!
    private var contacts: ContactList?
    private var contactsList: [Contact]?
    
    // MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.dataSource = dataSource
        contactsTableView.translatesAutoresizingMaskIntoConstraints = false
        contactsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contactsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contactsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contactsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contactsTableView.register(ContactsCell.nib, forCellReuseIdentifier: ContactsCell.identifier)
        contactsList = interactor?.displayTable()
        contacts = interactor?.contacts
        navigationItem.rightBarButtonItem = .init(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        navigationController?.navigationBar.prefersLargeTitles = true
        contactsTableView.delegate = self
    }
    
    // MARK: - DiffableDataSource
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, Contact> {
        let reuseIdentifier = cellReuseIdentifier
        
        return UITableViewDiffableDataSource(
            tableView: contactsTableView,
            cellProvider: {  tableView, indexPath, contact in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                ) as? ContactsCell
                cell?.titleLabel.text = contact.name
                cell?.detailLabel.text = contact.email
                return cell
            }
        )
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        switch section {
        case 0:
            label.text = "Friends"
        case 1:
            label.text = "Colleagues"
        case 2:
            label.text = "Family"
        default:
            label.text = "Undefined"
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            completion(true)
            var snapshot = self.dataSource.snapshot()
            guard let contact = self.dataSource.itemIdentifier(for: indexPath) else { return }
            snapshot.deleteItems([contact])
            self.dataSource.apply(snapshot)
            self.contactsTableView.reloadData()
        }
        editedContact = Contact(name: (contactsList?[indexPath.row].name)!, email: (contactsList?[indexPath.row].email)!, number: (contactsList?[indexPath.row].number)!, section: Section(rawValue: (contactsList?[indexPath.row].section)!.rawValue)!)
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, completion in
            completion(true)
            self.selectedPath = indexPath
            self.handleEdit()
            var snapshot = self.dataSource.snapshot()
            guard let contact = self.dataSource.itemIdentifier(for: indexPath) else { return }
            contact.name = self.editedContact.name
            contact.email = self.editedContact.email
            contact.number = self.editedContact.number
            contact.section = self.editedContact.section
            snapshot.appendItems([contact])
            self.dataSource.apply(snapshot)
        }
        return .init(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactsTableView.deselectRow(at: indexPath, animated: true)
        selectedPath = indexPath
        if #available(iOS 15.0, *) {
            selectedSection = dataSource.sectionIdentifier(for: indexPath.section)
        } else {
            return
        }
        routeToDetail()
    }
    
    func update(with list: ContactList, animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Contact>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list.friends, toSection: .friends)
        snapshot.appendItems(list.colleagues, toSection: .colleagues)
        snapshot.appendItems(list.family, toSection: .family)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    // MARK: - Routing
    @objc private func handleAdd() {
        editMode = false
        routeToAdd()
    }
    
    private func handleEdit() {
        editMode = true
        routeToAdd()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }

    func handleAddSegue(segue: UIStoryboardSegue) {
        let addView = segue.destination as? AddViewController
        if self.editMode == true {
            let selectedContact = contactsList?[selectedPath!.row]
            addView?.selectedContact = selectedContact
        }
        addView?.editMode = editMode
        addView!.callback = { item in
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems([.init(name: item[0], email: item[1], number: item[2], section: Section(rawValue: item[3])!)], toSection: Section.withLabel(item[3]))
            self.dataSource.apply(snapshot)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleDetailSegue(segue: UIStoryboardSegue) {
        let tableViewDetail = segue.destination as? DetailViewController
        guard let index = selectedPath?.row else { return }
        let selectedContact: Contact
        let errorContact: Contact = Contact(name: "Error", email: "Error", number: "Error", section: .friends)
        switch selectedSection {
        case .family:
            selectedContact = contacts?.family[index] ?? errorContact
        case .colleagues:
            selectedContact = contacts?.colleagues[index] ?? errorContact
        case .friends:
            selectedContact = contacts?.friends[index] ?? errorContact
        default:
            selectedContact = errorContact
        }
        tableViewDetail?.selectedContact = selectedContact
        tableViewDetail?.selectedSection = selectedSection
    }
    
    func routeToDetail() {
        router?.routeToDetail()
    }
    
    func routeToAdd() {
        router?.routeToAdd()
    }
}



