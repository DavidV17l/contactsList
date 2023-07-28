import UIKit
import FirebaseFirestore

protocol ICatalogDetailDisplayLogic: AnyObject {
    func reload()
    var selectedItem: Object? { get set }
}

class CatalogDetailViewController: UIViewController, ICatalogDetailDisplayLogic, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Variables
    let db = Firestore.firestore()
    
    var interactor: ICatalogDetailBusinessLogic?
    var router: (NSObjectProtocol & ICatalogDetailRoutingLogic & ICatalogDetailDataPassing)?
    
    @IBOutlet weak var collectionDetailView: UICollectionView! {
        didSet {
            collectionDetailView.delegate = self
            collectionDetailView.dataSource = self
            collectionDetailView.collectionViewLayout = createCollectionViewLayout()
        }
    }
    
    var selectedItem: Object?
    
    @IBOutlet weak var deleteButton: UIButton!
    private let reuseIdentifier = CatalogDetailCell.identifier
    
    //MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.tintColor = UIColor.red
        collectionDetailView.register(UINib(nibName: "CatalogDetailCell", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
        collectionDetailView.reloadData()
        navigationItem.rightBarButtonItem = .init(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
    }
    
    //MARK: - Collection View Logic
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CatalogDetailCell
        switch indexPath.item {
        case 0:
            cell.detailLabel.isHidden = true
            cell.imageView.image = UIImage(named: selectedItem?.picture ?? "")
            cell.titleLabel.text = selectedItem?.title
        case 1:
            cell.imageView.isHidden = true
            cell.titleLabel.text = selectedItem?.desc1
            cell.detailLabel.text = selectedItem?.detail1
        case 2:
            cell.imageView.isHidden = true
            cell.titleLabel.text = selectedItem?.desc2
            cell.detailLabel.text = selectedItem?.detail2
        default:
            break
        }
        return cell
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        guard let itemid = selectedItem?.id else { return }
        db.collection("objects").document(itemid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        navigationController?.popViewController(animated: true)
        router?.dataStore?.vc?.updateList()
    }
    
    func reload() {
        collectionDetailView.reloadData()
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }
    
    @objc func editButtonPressed() {
        router?.routeToEdit()
    }
}
