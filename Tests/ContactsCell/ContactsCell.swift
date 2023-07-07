//
//  ContactsCell.swift
//  Tests
//
//  Created by davide on 29/06/23.
//

import UIKit

class ContactsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Set the identifier for the custom cell
    static let identifier = "TheCell"

    // Returning the xib file after instantiating it
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func updateCell(name: String, email: String)
        {
            self.titleLabel.text = name
            self.detailLabel.text = email
        }
}
