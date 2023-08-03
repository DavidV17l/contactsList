import UIKit
import Eureka

final class CustomCell: Cell<User>, CellType {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        super.setup()
        selectionStyle = .none
        nameLabel.font = .systemFont(ofSize: 18)
        mailLabel.font = .systemFont(ofSize: 13.3)
        dateLabel.font = .systemFont(ofSize: 13.3)
        height = { return 100 }
        backgroundColor = UIColor(red:0.984, green:0.988, blue:0.976, alpha:1.00)
    }
    
    override func update() {
        super.update()
        textLabel?.text = nil
        guard let user = row.value else { return }
        mailLabel.text = user.email
        nameLabel.text = user.name
        dateLabel.text = user.dateOfBirth
    }
}
