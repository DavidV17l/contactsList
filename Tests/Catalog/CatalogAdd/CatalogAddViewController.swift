import UIKit
import FirebaseFirestore

protocol ICatalogAddDisplayLogic: AnyObject {}

class CatalogAddViewController: UIViewController, ICatalogAddDisplayLogic, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    //MARK: - Variables
    var interactor: ICatalogAddBusinessLogic?
    var router: (NSObjectProtocol & ICatalogAddRoutingLogic & ICatalogAddDataPassing)?
    
    let db = Firestore.firestore()
    
    var counter: String = UUID().uuidString
    private let reuseIdentifier = CatalogAddCell.identifier
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.collectionViewLayout = createCollectionViewLayout()
        }
    }
    
    var titleText: String = ""
    var imageText: String = ""
    var desc1: String = ""
    var desc2: String = ""
    var det1: String = ""
    var det2: String = ""
    var id: String = ""
    
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CatalogAddCell", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
        if (router?.dataStore?.item) != nil {
            addButton.titleLabel?.text = "Edit"
            navigationItem.rightBarButtonItem = .init(title: "Reset", style: .plain, target: self, action: #selector(resetFields))
        } else {
            navigationItem.rightBarButtonItem = .init(title: "Clear", style: .plain, target: self, action: #selector(clearFields))
        }
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }
    
    //MARK: - CollectionView Add Element Logic
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = router?.dataStore?.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CatalogAddCell
        cell.textField.delegate = self
        switch indexPath.item {
        case 0:
            cell.textField.text = titleText
            cell.textField.tag = indexPath.item
            cell.textField.text = item?.title
            self.titleText = item?.title ?? ""
        case 1:
            cell.textField.text = imageText
            cell.textField.tag = indexPath.item
            cell.textField.text = item?.picture
            self.imageText = item?.picture ?? ""
        case 2:
            cell.textField.text = desc1
            cell.textField.tag = indexPath.item
            cell.textField.text = item?.desc1
            self.desc1 = item?.desc1 ?? ""
        case 3:
            cell.textField.text = det1
            cell.textField.tag = indexPath.item
            cell.textField.text = item?.detail1
            self.det1 = item?.detail1 ?? ""
        case 4:
            cell.textField.text = desc2
            cell.textField.tag = indexPath.item
            cell.textField.text = item?.desc2
            self.desc2 = item?.desc2 ?? ""
        case 5:
            cell.textField.text = det2
            cell.textField.tag = indexPath.item
            cell.textField.text = item?.detail2
            self.det2 = item?.detail2 ?? ""
        default: break
        }
        return cell
    }
    
    
    
    @IBAction func addElementButtonPressed(_ sender: Any) {
        if let item = router?.dataStore?.item {
            let newItem = Object(id: item.id, title: titleText, picture: imageText, detail1: det1, detail2: det2, desc1: desc1, desc2: desc2)
            db.collection("objects").document("\(item.id)").setData([
                "title": titleText,
                "picture": imageText,
                "desc1": desc1,
                "desc2": desc2,
                "detail1": det1,
                "detail2": det2,
                "id": item.id
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            navigationController?.popViewController(animated: true)
            router?.dataStore?.detailVC?.selectedItem = newItem
            router?.dataStore?.detailVC?.reload()
            router?.dataStore?.vc?.updateList()
        } else {
            if titleText.isEmpty || imageText.isEmpty || desc1.isEmpty || desc2.isEmpty || det1.isEmpty || det2.isEmpty {
                let cells = collectionView.visibleCells as! [CatalogAddCell]
                for cell in cells {
                    if cell.textField.text == "" {
                        cell.errorLabel.isHidden = false
                        cell.textField.layer.borderWidth = 1
                        cell.textField.layer.borderColor = UIColor.red.cgColor
                    }
                }
            } else {
                db.collection("objects").document("object\(counter)").setData([
                    "title": titleText,
                    "picture": imageText,
                    "desc1": desc1,
                    "desc2": desc2,
                    "detail1": det1,
                    "detail2": det2,
                    "id": "object\(counter)"
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                counter = UUID().uuidString
                navigationController?.popViewController(animated: true)
                router?.dataStore?.vc?.updateList()
            }
        }
        
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    @objc func valueChanged(_ textField: UITextField){
        
        guard let text = textField.text else { return }
        
        switch textField.tag {
        case 0: titleText = text
        case 1: imageText = text
        case 2: desc1 = text
        case 3: det1 = text
        case 4: desc2 = text
        case 5: det2 = text
        default:
            break
        }
    }
    
    @objc func resetFields() {
        guard let item = router?.dataStore?.item else { return }
        titleText = item.title!
        imageText = item.picture!
        desc1 = item.desc1!
        desc2 = item.desc2!
        det1 = item.detail1!
        det2 = item.detail2!
        collectionView.reloadData()
    }
    
    @objc func clearFields() {
        titleText = ""
        imageText = ""
        desc1 = ""
        det1 = ""
        desc2 = ""
        det2 = ""
        collectionView.reloadData()
    }
}
