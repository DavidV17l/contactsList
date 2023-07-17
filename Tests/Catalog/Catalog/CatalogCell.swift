import UIKit

class CatalogCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    static let identifier = "catalogCell"
}
