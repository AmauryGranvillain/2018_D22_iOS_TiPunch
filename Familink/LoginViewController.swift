//
//  LoginViewController.swift
//  Familink
//
//  Created by formation12 on 23/01/2019.
//  Copyright © 2019 ti.punch. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func tapOnLogin(_ sender: UIButton) {
        
        print("tap login")
        //TODO: if verif :
            NotificationCenter.default.post(name: Notification.Name("login"), object: self)
        
        // else
        
        
    }
}
