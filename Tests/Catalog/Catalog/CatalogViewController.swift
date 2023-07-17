import UIKit

protocol ICatalogDisplayLogic: AnyObject {
    func update(with list: ObjectList, animate: Bool)
    var selectedPath: IndexPath? { get set }
    var catalogList: [Object]? { get set }
}

class CatalogViewController: UIViewController, ICatalogDisplayLogic, UICollectionViewDelegate {
    
    //MARK: - Typealias
    fileprivate typealias CatalogDataSource = UICollectionViewDiffableDataSource<CatalogSection, Object>
    fileprivate typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<CatalogSection, Object>
    
    //MARK: - Variables
    var interactor: ICatalogBusinessLogic?
    var router: (NSObjectProtocol & ICatalogRoutingLogic & ICatalogDataPassing)?
    
    private let cellReuseIdentifier = CatalogCell.identifier
    private var dataSource: CatalogDataSource!
    
    var catalog: ObjectList?
    var catalogList: [Object]?
    var selectedPath: IndexPath?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = dataSource
            collectionView.collectionViewLayout = createCollectionViewLayout()
        }
    }
    
    //MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catalog = interactor?.objects
        catalogList = interactor?.objectList
        configureDataSource()
        let margin: CGFloat = 10
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Collection View Logic
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func update(with list: ObjectList, animate: Bool = true) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections(CatalogSection.allCases)
        snapshot.appendItems(list.everything, toSection: .everything)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    private func configureDataSource() {
        dataSource = CatalogDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, object) -> CatalogCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! CatalogCell
            cell.label.text = object.title
            cell.image.image = object.picture
            return cell
        })
        guard let list = catalogList else { return }
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([CatalogSection.everything])
        snapshot.appendItems(list)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedPath = indexPath
        routeToDetail()
    }
    
    //MARK: - Routing
    func routeToDetail() {
        router?.routeToDetail()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }
}
