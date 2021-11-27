//
//  LoginViewController.swift
//  ExpenseTracker
//
//  Created by Mahavir Makwana on 27/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


//MARK: - IBActions
extension LoginViewController {

    @IBAction func btnDoneTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let pass = StandardUserDefaults.getCustomObject(key: "Password") as? String ?? ""
        if txtPassword.text?.trimmed() == pass {
            AppUtility.sharedAppDel.setHomeNavigation()
        }
        else {
            self.view.makeToast("Incorrect Password")
        }
    }
}
