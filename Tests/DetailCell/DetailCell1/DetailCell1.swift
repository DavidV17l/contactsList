import UIKit

class DetailCell1: UITableViewCell, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    weak var delegate: IDetailViewDisplayLogic?
    
    @IBAction func chooseButtonPressed(_ sender: UIButton) {
        delegate?.buttonPressedCell(sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.layer.cornerRadius = profileImage.bounds.width/2
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "DetailCell1"

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
