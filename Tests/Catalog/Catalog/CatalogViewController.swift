import UIKit

protocol ICatalogDisplayLogic: AnyObject {
    func update(with list: [Object], animate: Bool)
    func updateList()
    var catalogList: [Object]? { get set }
}

class CatalogViewController: UIViewController, ICatalogDisplayLogic, UICollectionViewDelegate, UISearchResultsUpdating {
    
    //MARK: - Typealias
    private typealias CatalogDataSource = UICollectionViewDiffableDataSource<CatalogSection, Object>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<CatalogSection, Object>
    
    //MARK: - Variables
    var interactor: ICatalogBusinessLogic?
    var router: (NSObjectProtocol & ICatalogRoutingLogic & ICatalogDataPassing)?
    
    private let cellReuseIdentifier = CatalogCell.identifier
    
    private lazy var dataSource: CatalogDataSource = {
        return {
            CatalogDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, object) -> CatalogCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! CatalogCell
                cell.label.text = object.title
                cell.image.image = UIImage(named: object.picture ?? "")
                return cell
            })
        }()
    }()
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    var catalogList: [Object]?
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
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
        loader.startAnimating()
        initNavigation()
        interactor?.initializer()
    }
    
    func initNavigation() {
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.rightBarButtonItem = .init(title: NSLocalizedString("AddButton", comment: "Button name"), style: .plain, target: self, action: #selector(handleAdd))
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK: - Collection View Logic
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(171.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(171.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func update(with list: [Object], animate: Bool = true) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections(CatalogSection.allCases)
        snapshot.appendItems(list, toSection: .everything)
        dataSource.apply(snapshot, animatingDifferences: animate)
        loader.stopAnimating()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard var dataStore = router?.dataStore else { return }
        dataStore.selectedItem = dataSource.snapshot().itemIdentifiers[indexPath.item]
        routeToDetail()
    }
    
    //MARK: - Search Bar Logic
    func updateSearchResults(for searchController: UISearchController) {
        guard var list: [Object] = catalogList else { return }
        list = filteredObjects(for: searchController.searchBar.text)
        update(with: list)
    }
    
    func filteredObjects(for searchText: String?) -> [Object] {
        guard let objs = catalogList else { return catalogList ?? [] }
        guard let query = searchText, !query.isEmpty else { return objs }
        return objs.filter { obj in
            let matches = obj.title?.lowercased().contains(query.lowercased())
            return matches ?? false
        }
    }
    
    //MARK: - Routing
    internal func routeToDetail() {
        router?.routeToDetail()
    }
    
    @objc private func handleAdd() {
        router?.routeToAdd()
    }
    
    internal func updateList() {
        interactor?.objectList = []
        interactor?.objects = nil
        interactor?.initializer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }
}
