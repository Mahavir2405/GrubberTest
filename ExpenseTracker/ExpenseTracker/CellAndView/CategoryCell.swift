//
//  CategoryCell.swift
//  ExpenseTracker
//
//  Created by Mahavir Makwana on 27/11/21.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var btnCheckBox: UIButton!

    var category: Categories! {
        didSet {
            lblTitle.text = category.name
            btnCheckBox.isSelected = category.isSelected
            btnCheckBox.isUserInteractionEnabled = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
