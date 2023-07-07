//
//  TableViewCell.swift
//  Tests
//
//  Created by davide on 28/06/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var textLabelCell: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Set the identifier for the custom cell
    static let identifier = "TheCell"

    // Returning the xib file after instantiating it
    static var nib: UINib {
           return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func updateCell(name: String, img: String?)
        {
            self.textLabelCell.text = name
            self.imageViewCell.image = UIImage(named: img!)
        }
    
}
