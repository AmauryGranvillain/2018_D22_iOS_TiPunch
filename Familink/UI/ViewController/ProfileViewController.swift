//
//  ProfileViewController.swift
//  Familink
//
//  Created by formation12 on 23/01/2019.
//  Copyright © 2019 ti.punch. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    let profils = ["Senior" ,"Famille" ,"Medecin"]
    
    func displayAlertForInvalidField(message: String, toFocus: UITextField) {
        let alert = UIAlertController(
            title: "Erreur sur le formulaire",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        toFocus.becomeFirstResponder()
        self.present(alert, animated: true)
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
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        var validEmail = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        return validEmail
    }
    
    func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    func isEnabledTextInput(bool: Bool) {
        self.firstNameTextImput.isUserInteractionEnabled = bool
        self.lastNameTextImput.isUserInteractionEnabled = bool
        self.phoneTextImput.isUserInteractionEnabled = bool
        self.mailTextImput.isUserInteractionEnabled = bool
        self.profilPicker.isUserInteractionEnabled = bool
    }

    @IBOutlet weak var firstNameTextImput: UITextField!
    @IBOutlet weak var lastNameTextImput: UITextField!
    @IBOutlet weak var phoneTextImput: UITextField!
    @IBOutlet weak var mailTextImput: UITextField!
    @IBOutlet weak var profilPicker: UIPickerView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var firstNameTextLabel: UILabel!
    @IBOutlet weak var lastNameTextLabel: UILabel!
    @IBOutlet weak var phoneNumberTextLabel: UILabel!
    @IBOutlet weak var profilPickerTextLabel: UILabel!
    @IBOutlet weak var mailTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.profilPicker.delegate = self
        self.profilPicker.dataSource = self
        self.saveButton.isHidden = true
        self.editButton.isHidden = false
        isEnabledTextInput(bool: false)
        
        APIClient.instance.getUser(onSucces: { (user) in
            print("User présent")
            let currentUser = user[0]
            self.firstNameTextImput.text = currentUser.firstName
            self.lastNameTextImput.text = currentUser.lastName
            self.mailTextImput.text = currentUser.email
            self.phoneTextImput.text = currentUser.phone
        }) { (Int) in
            print("Pas là")
        }
       
        // Do any additional setup after loading the view.
    }
    @IBAction func tapToSave(_ sender: UIButton) {
        
        if (self.phoneTextImput.text?.count)! > 10  {
            displayAlertForInvalidField(message: "Telephone invalide", toFocus: phoneTextImput)
        } else if !isValidEmail(email: self.mailTextImput.text!){
            displayAlertForInvalidField(message: "Email invalide", toFocus: mailTextImput)
        } else {
            self.saveButton.isHidden = true
            self.editButton.isHidden = false
            isEnabledTextInput(bool: false)
        
            let currentUser = User(context: self.getContext()!)
            currentUser.firstName = self.firstNameTextImput.text
            currentUser.lastName = self.lastNameTextImput.text
            currentUser.email = self.mailTextImput.text
            currentUser.phone = self.phoneTextImput.text
            
            /*APIClient.instance.updateUser(u: currentUser, onSucces: { (user) in
            }) { (e) in
                print("Pas update")
            }*/
        }
        
    } //TODO: update avec l'api
    @IBAction func tapToEdit(_ sender: UIButton) {
        
        self.saveButton.isHidden = false
        self.editButton.isHidden = true
        isEnabledTextInput(bool: true)
        
        // TODO: change UI
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
