import UIKit

class Cell3: UICollectionViewCell {
    
    @IBOutlet weak var description2Label: UILabel!
    @IBOutlet weak var detail2Label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
