//
//  SignUpViewController.swift
//  Familink
//
//  Created by formation12 on 24/01/2019.
//  Copyright © 2019 ti.punch. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let profils = ["Senior" ,"Famille" ,"Medecin"]
    
    @IBOutlet weak var phoneTextImput: UITextField!
    @IBOutlet weak var lastNameTextImput: UITextField!
    @IBOutlet weak var firstNameTextImput: UITextField!
    @IBOutlet weak var mailTextImput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    @IBOutlet weak var confirmPasswordTextInput: UITextField!
    @IBOutlet weak var profilPicker: UIPickerView!
    @IBOutlet weak var lastNameTextLabel: UILabel!
    @IBOutlet weak var phoneNumberTextLabel: UILabel!
    @IBOutlet weak var firstNameTextLabel: UILabel!
    @IBOutlet weak var mailTextLabel: UILabel!
    @IBOutlet weak var profilPickerTextLabel: UILabel!
    @IBOutlet weak var passwordTextLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextLabel: UILabel!

    var password: String!
    var userPhone: String?
    var profile: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilPicker.delegate = self
        profilPicker.dataSource = self
    }
    
    @IBAction func signUpUiButton(_ sender: UIButton) {
        if(ConnectedClient.instance.isConnectedToNetwork()){
            let newUser = User(context: self.getContext()!)
            newUser.phone = phoneTextImput.text
            newUser.firstName = firstNameTextImput.text
            newUser.lastName = lastNameTextImput.text
            newUser.email = mailTextImput.text
            newUser.profile = profile ?? "SENIOR"
            
            if phoneTextImput.text == "" {
                self.getAlert(message: "Le champ téléphone est vide")
            } else if firstNameTextImput.text == "" { 
                self.getAlert(message: "Le champ prénom est vide")
            } else if lastNameTextImput.text == "" {
                self.getAlert(message: "Le champ nom est vide")
            } else if mailTextImput.text == "" {
                self.getAlert(message: "Le champ email est vide")
            }
            
            if passwordTextInput.text == confirmPasswordTextInput.text {
                password = passwordTextInput.text
                createUser(u: newUser, password: password)
            } else {
                self.getAlert(message: "Les mots de passes sont différents")
            }
        } else {
            let alert = UIAlertController(
                title: "Erreur de connexion",
                message: "Voulez-vous passer en mode hors-ligne ?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (sender) in
                NotificationCenter.default.post(name: Notification.Name("offline"), object: self)
            }))
            alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return profils[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        profile = profils[row].uppercased()
    }
    
    func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func getAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Erreur sur le formulaire",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    func createUser(u: User, password: String) {
        APIClient.instance.createUser(u: u, password: password, onSucces: { (success) in
            DispatchQueue.main.async {
                let controller = UIStoryboard.init(
                    name: "Main",
                    bundle: nil).instantiateViewController(
                        withIdentifier: "LoginViewController") as! LoginViewController
                
                controller.userPhone = u.phone 
                
                self.navigationController?.show(controller, sender: self)
            }
        }) { (error) in
            DispatchQueue.main.async {
                print(error)
            }
        }
    }
}
