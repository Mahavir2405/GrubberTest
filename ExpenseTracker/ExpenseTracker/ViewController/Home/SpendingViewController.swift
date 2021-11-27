//
//  SpendingViewController.swift
//  ExpenseTracker
//
//  Created by Mahavir Makwana on 27/11/21.
//

import UIKit

class SpendingViewController: UIViewController {

    @IBOutlet private weak var tblTransaction: UITableView!

    private var arrList: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let totalCategoryRecords = DBManager.shared.getTotalRecordCount("SELECT COUNT(category_id) FROM Category")

        if totalCategoryRecords == 0 {
            _ = DBManager.shared.insertIntoCategory(arrCategory: AppUtility.shared.arrCategory)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        getAllTransactions()
    }
}

//MARK: - IBActions
extension SpendingViewController {

    @IBAction func btnExpenseTapped(_ sender: UIButton) {
        if let vc = AppUtility.STORY_BOARD().instantiateViewController(withIdentifier: "NewTransactionViewController") as? NewTransactionViewController {
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc)
            vc.selectedSegment = NewTransactionViewController.TransactionType.expense

        }
    }

    @IBAction func btnIncomeTapped(_ sender: UIButton) {
        if let vc = AppUtility.STORY_BOARD().instantiateViewController(withIdentifier: "NewTransactionViewController") as? NewTransactionViewController {
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc)
            vc.selectedSegment = NewTransactionViewController.TransactionType.income
        }
    }
}

//MARK: - Other Actions
extension SpendingViewController {
    private func getAllTransactions() {
        arrList = DBManager.shared.getRecordsFromTransactions()
        tblTransaction.reloadData()
    }
}

//MARK: - Other Actions
extension SpendingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell {
            cell.selectionStyle = .none
            let transaction = arrList[indexPath.row]
            cell.transaction = transaction
            return cell
        }
        return UITableViewCell()
    }
}
