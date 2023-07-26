import UIKit

class CatalogCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    static let identifier = "catalogCell"
    
    var cornerRadius: CGFloat = 10.0
    var designColor: CGColor = UIColor(red: 0.92, green: 0.91, blue: 1.00, alpha: 1.00).cgColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        contentView.layer.backgroundColor = designColor
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        layer.backgroundColor = designColor
        
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
}
