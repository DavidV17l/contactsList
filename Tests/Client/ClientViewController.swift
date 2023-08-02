import UIKit

protocol IClientDisplayLogic: AnyObject {
    var factsList: [CatFact] { get set }
    func initCompleted()
}

class ClientViewController: UIViewController, IClientDisplayLogic, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Variables
    var interactor: IClientBusinessLogic?
    var router: (NSObjectProtocol & IClientRoutingLogic & IClientDataPassing)?
    
    var factsList: [CatFact] = []
    var fillCells: Bool = false
    
    let reuseIdentifier: String = ClientCell.identifier
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.collectionViewLayout = createCollectionViewLayout()
            collectionView.register(UINib(nibName: "ClientCell", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
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
        interactor?.initializeClient()
    }
    
    func initCompleted() {
        loader.stopAnimating()
        fillCells = true
        collectionView.reloadData()
    }
    
    //MARK: - Logic
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if fillCells == true {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ClientCell
            cell.title.text = self.factsList[indexPath.item].id
            cell.fact.text = self.factsList[indexPath.item].text
            return cell
        } else { return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ClientCell }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fillCells == true {
            return factsList.count
        } else { return 0 }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router?.prepare(for: segue, sender: sender)
    }
}
