//
//  NewTransactionViewController.swift
//  ExpenseTracker
//
//  Created by Mahavir Makwana on 27/11/21.
//

import UIKit
import Toast

class NewTransactionViewController: UIViewController {

    @IBOutlet private weak var segmentTransactionType: UISegmentedControl!
    @IBOutlet private weak var txtDate: UITextField!
    @IBOutlet private weak var txtAmount: UITextField!
    @IBOutlet private weak var txtCategory: UITextField!
    @IBOutlet private weak var txtNote: UITextField!

    enum TransactionType: Int {
        case expense = 0
        case income = 1
    }

    var selectedSegment: TransactionType! = .expense {
        didSet {
            segmentTransactionType.selectedSegmentIndex = selectedSegment == .expense ? 0 : 1
        }
    }

    var selectedDate: Date? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
}

//MARK: - IBActions
extension NewTransactionViewController {

    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController()
    }

    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        //insert into DB
        if txtDate.text?.isEmpty == true {
            self.view.makeToast("Please select date")
        }
        else if txtAmount.text?.trimmed().isEmpty == true {
            self.view.makeToast("Please enter amount")
        }
        else if txtCategory.text?.trimmed().isEmpty == true {
            self.view.makeToast("Please select categories")
        }
        else {
            let totalCategoryRecords = DBManager.shared.getTotalRecordCount("SELECT COUNT(transactions_id) FROM Transactions")

            let transaction = Transaction(dict: nil)
            transaction.ID = totalCategoryRecords + 1
            transaction.title = txtNote.text ?? ""
            transaction.amount = Double(txtAmount.text ?? "0.0")
            transaction.date = txtDate.text ?? ""
            transaction.category = txtCategory.text ?? ""

            _ = DBManager.shared.insertIntoTransaction(arrTransactions: [transaction])
            self.navigationController?.popViewController()
        }
    }
}

//MARK: - Other Actions
extension NewTransactionViewController {
    private func initialSetup() {
        //segmentTransactionType.selectedSegmentIndex = 0
    }

    private func openDateSelectionView(textField: UITextField) {
        let style = RMActionControllerStyle.white

        let selectAction = RMAction<UIDatePicker>(title: "Select", style: RMActionStyle.done) { controller in
            print("Successfully selected date: ", controller.contentView.date)

            self.selectedDate = controller.contentView.date
            self.txtDate.text = "\(controller.contentView.date.toString(format: "dd/MM/yyyy"))"
        }

        var title = "Select Date"

        let cancelAction = RMAction<UIDatePicker>(title: "Cancel", style: RMActionStyle.cancel) { _ in
            print("Date selection was canceled")
        }

        let actionController = RMDateSelectionViewController(style: style, title: title, message: "", select: selectAction, andCancel: cancelAction)!

        //You can enable or disable blur, bouncing and motion effects
        actionController.disableBouncingEffects = false
        actionController.disableMotionEffects = false
        actionController.disableBlurEffects = true

        //You can access the actual UIDatePicker via the datePicker property
        if #available(iOS 13.4, *) {
            actionController.datePicker.preferredDatePickerStyle = .wheels
        }
        actionController.datePicker.datePickerMode = .date
        actionController.datePicker.minuteInterval = 5
        actionController.datePicker.date = Date()
        actionController.datePicker.maximumDate = Date()

        //Now just present the date selection controller using the standard iOS presentation method
        present(actionController, animated: true, completion: nil)
    }

    private func openCategoryList() {
        if let vc = AppUtility.STORY_BOARD().instantiateViewController(withIdentifier: "CategoryListViewController") as? CategoryListViewController {
            vc.hidesBottomBarWhenPushed = true
            vc.onComplete = { arrCat in
                self.txtCategory.text = arrCat.map{ $0.name! }.joined(separator: ",")
            }
            self.navigationController?.pushViewController(vc)
        }
    }
}

//MARK: - UITextField Delegate
extension NewTransactionViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDate {
            openDateSelectionView(textField: textField)
            return false
        }
        else if textField == txtCategory {
            openCategoryList()
            return false
        }
        return true
    }
}
