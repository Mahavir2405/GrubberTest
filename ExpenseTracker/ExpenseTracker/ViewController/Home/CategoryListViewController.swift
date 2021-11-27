//
//  CategoryListViewController.swift
//  ExpenseTracker
//
//  Created by Mahavir Makwana on 27/11/21.
//

import UIKit

class CategoryListViewController: UIViewController {

    @IBOutlet private weak var tblCategory: UITableView!

    private var arrList: [Categories] = []

    var onComplete: (([Categories])->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        getAllCategories()
    }
}

//MARK: - IBActions
extension CategoryListViewController {

    @IBAction func btnDoneTapped(_ sender: UIButton) {
        let arrSelected = arrList.filter({ $0.isSelected })
        onComplete?(arrSelected)
        self.navigationController?.popViewController()
    }
}

//MARK: - Other Actions
extension CategoryListViewController {
    private func getAllCategories() {
        arrList = DBManager.shared.getRecordsFromCategory()
        tblCategory.reloadData()
    }
}

//MARK: - Other Actions
extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell {
            cell.selectionStyle = .none
            let category = arrList[indexPath.row]
            cell.category = category
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrList[indexPath.row].isSelected = !arrList[indexPath.row].isSelected
        tblCategory.reloadData()
    }
}
