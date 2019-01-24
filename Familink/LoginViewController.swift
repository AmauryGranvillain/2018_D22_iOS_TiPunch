//
//  LoginViewController.swift
//  Familink
//
//  Created by formation12 on 23/01/2019.
//  Copyright © 2019 ti.punch. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController {

    @IBOutlet weak var phoneTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func tapOnLogin(_ sender: UIButton) {
        print("tap login")
        //Todo: if verif
            NotificationCenter.default.post(name: Notification.Name("login"), object: self)
        // else
    }

    @IBAction func tapOnforgetPassword(_ sender: Any) {
    }
    @IBAction func switchRemenberMe(_ sender: Any) {
    }
}
