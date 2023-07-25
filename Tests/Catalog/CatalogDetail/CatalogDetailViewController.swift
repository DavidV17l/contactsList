import UIKit
import FirebaseFirestore

protocol ICatalogDetailDisplayLogic: AnyObject {
    var selectedItem: Object? { get set }
}

class CatalogDetailViewController: UIViewController, ICatalogDetailDisplayLogic, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Variables
    let db = Firestore.firestore()
    
    var interactor: ICatalogDetailBusinessLogic?
    var router: (NSObjectProtocol & ICatalogDetailRoutingLogic & ICatalogDetailDataPassing)?
    
    let cellsID: [String] = ["catalogDetailCell", "catalogDesc1", "catalogDesc2"]
    
    @IBOutlet weak var collectionDetailView: UICollectionView! {
        didSet {
            collectionDetailView.delegate = self
            collectionDetailView.dataSource = self
            collectionDetailView.collectionViewLayout = createCollectionViewLayout()
        }
    }
    
    var selectedItem: Object?

    @IBOutlet weak var deleteButton: UIButton!
    
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
        collectionDetailView.reloadData()
    }
    
    //MARK: - Collection View Logic
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsID.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellsID[0], for: indexPath) as? Cell {
            cell.mainImage.image = UIImage(named: selectedItem?.picture ?? "")
            cell.titleLabel.text = selectedItem?.title
            return cell
        }
        case 1: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellsID[1], for: indexPath) as? Cell2 {
            cell.descriptionLabel.text = selectedItem?.desc1
            cell.detailLabel.text = selectedItem?.detail1
            return cell
        }
        case 2: if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellsID[2], for: indexPath) as? Cell3 {
            cell.description2Label.text = selectedItem?.desc2
            cell.detail2Label.text = selectedItem?.detail2
            return cell
        }
        default: break
        }
        return UICollectionViewCell()
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
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }
}
