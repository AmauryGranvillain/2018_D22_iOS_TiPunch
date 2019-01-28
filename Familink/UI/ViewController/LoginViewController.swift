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
    @IBOutlet weak var phoneNumberTextLabel: UILabel!
    @IBOutlet weak var passwordTextLabel: UILabel!
    @IBOutlet weak var rememberMeTextLabel: UILabel!
    var userPhone: String?
    var userPassword: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func tapOnLogin(_ sender: UIButton) {
        userPhone =  phoneTextInput.text
        userPassword = passwordTextInput.text
        print(userPhone ?? "")
        print(userPassword ?? "")
        APIClient.instance.login(phone: userPhone ?? "", password: userPassword ?? "", onSucces: { (Result) in
            NotificationCenter.default.post(name: Notification.Name("login"), object: self)
            print(Result)
        }) { (Error) in
            print(Error)
            self.checkError(error: Error)
        }
    }

    @IBAction func tapOnforgetPassword(_ sender: Any) {
    }
    @IBAction func switchRemenberMe(_ sender: Any) {
    }
    
    func checkError(error: String) {
        switch error {
        case "User not found":
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Erreur sur le formulaire",
                    message: "Le numéro de téléphone est incorrecte",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
        case "Password is not valid":
             DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Erreur sur le formulaire",
                    message: "Le mot de passe est incorrecte",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
        default :
            let alert = UIAlertController(
                title: "Erreur sur le formulaire",
                message: "Une erreur est survenu, veuillez vérifier vos informations",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
}
