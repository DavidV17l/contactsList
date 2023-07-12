//
//  DetailCell2.swift
//  Tests
//
//  Created by davide on 11/07/23.
//

import UIKit

class DetailCell2: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: IDetailViewDisplayLogic?
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let text = label.text else { return }
        if button.currentTitle == "Send" {
            delegate?.callNumber(phoneNumber: text)
        }
        else if button.currentTitle == "Call" {
            delegate?.sendMail(mailAddress: text)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static let identifier = "DetailCell2"

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
