//
//  DetailCell.swift
//  Tests
//
//  Created by davide on 05/07/23.
//

import UIKit

class AddCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Set the identifier for the custom cell
    static let identifier = "TheAddCell"

    // Returning the xib file after instantiating it
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
