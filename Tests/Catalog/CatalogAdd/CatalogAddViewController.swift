import UIKit
import FirebaseFirestore

protocol ICatalogAddDisplayLogic: AnyObject {}

class CatalogAddViewController: UIViewController, ICatalogAddDisplayLogic, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    //MARK: - Variables
    var interactor: ICatalogAddBusinessLogic?
    var router: (NSObjectProtocol & ICatalogAddRoutingLogic & ICatalogAddDataPassing)?
    
    let db = Firestore.firestore()
    
    var counter: Int = Int.random(in: 10..<100000000)
    
    var cellsID: [String] = ["catalogAddCell", "catalogAddCell2", "catalogAddCell3", "catalogAddCell4", "catalogAddCell5", "catalogAddCell6"]
    
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
    
    //MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        switch indexPath.item {
        case 0: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellsID[0], for: indexPath) as? CatalogAddCell {
            cell.textField.tag = indexPath.item
            cell.textField.delegate = self
            return cell
        }
        case 1: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellsID[1], for: indexPath) as? CatalogAddCell2 {
            cell.textField.tag = indexPath.item
            cell.textField.delegate = self
            return cell
        }
        case 2: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellsID[2], for: indexPath) as? CatalogAddCell3 {
            cell.textField.tag = indexPath.item
            cell.textField.delegate = self
            return cell
        }
        case 3: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellsID[3], for: indexPath) as? CatalogAddCell4 {
            cell.textField.tag = indexPath.item
            cell.textField.delegate = self
            return cell
        }
        case 4: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellsID[4], for: indexPath) as? CatalogAddCell5 {
            cell.textField.tag = indexPath.item
            cell.textField.delegate = self
            return cell
        }
        case 5: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellsID[5], for: indexPath) as? CatalogAddCell6 {
            cell.textField.tag = indexPath.item
            cell.textField.delegate = self
            return cell
        }
        default: break }
        return UICollectionViewCell()
    }
    
    
    
    @IBAction func addElementButtonPressed(_ sender: Any) {
        if titleText.isEmpty || imageText.isEmpty || desc1.isEmpty || desc2.isEmpty || det1.isEmpty || det2.isEmpty {
            let alert: UIAlertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Fields", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler:  nil))
            self.present(alert, animated: true, completion: nil)
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
            counter += 1
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80.0))
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
}
