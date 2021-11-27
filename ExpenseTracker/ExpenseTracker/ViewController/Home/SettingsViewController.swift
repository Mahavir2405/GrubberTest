//
//  SettingsViewController.swift
//  ExpenseTracker
//
//  Created by Mahavir Makwana on 27/11/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var txtConfirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}


//MARK: - IBActions
extension SettingsViewController {

    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController()
    }

    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if txtPassword.text?.trimmed().isEmpty == true {
            self.view.makeToast("Please enter password")
        }
        else if txtConfirmPassword.text?.trimmed().isEmpty == true {
            self.view.makeToast("Please enter confirm password")
        }
        else if txtPassword.text! != txtConfirmPassword.text! {
            self.view.makeToast("Password doesn't matched")
        }
        else {
            txtPassword.text = ""
            txtConfirmPassword.text = ""
            StandardUserDefaults.setCustomObject(obj: txtPassword.text!, key: "Password")
            AppUtility.shared.homeNavController?.selectedIndex = 0
        }
    }
}
