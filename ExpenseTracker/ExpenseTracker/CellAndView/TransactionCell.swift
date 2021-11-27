//
//  TransactionCell.swift
//  ExpenseTracker
//
//  Created by Mahavir Makwana on 27/11/21.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblAmount: UILabel!

    var transaction: Transaction! {
        didSet {
            lblTitle.text = transaction.title.isEmpty ? "Expense" : transaction.title
            lblAmount.text = String(format: "%.00f", transaction.amount)
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
