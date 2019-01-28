//
//  DetailsContactViewController.swift
//  Familink
//
//  Created by formation12 on 23/01/2019.
//  Copyright © 2019 ti.punch. All rights reserved.
//

import UIKit

class DetailsContactViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var contact: Contact = Contact();
    

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var lastNameTextInput: UITextField!
    @IBOutlet weak var gravatarImageView: UIImageView!
    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var phoneTextInput: UITextField!
    @IBOutlet weak var firstNameTextInput: UITextField!
    @IBOutlet weak var profilPicker: UIPickerView!
    @IBOutlet weak var phoneNumberTextLabel: UILabel!
    @IBOutlet weak var mailTextLabel: UILabel!
    @IBOutlet weak var profilPickerTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilPicker.delegate = self
        profilPicker.dataSource = self
        self.saveButton.isHidden = true
        self.editButton.isHidden = false
        
        self.firstNameTextInput.text = self.contact.firstName
        self.lastNameTextInput.text = self.contact.lastName
        self.phoneTextInput.text = self.contact.phone
        self.emailTextInput.text = self.contact.email
        if let url = URL(string: contact.gravatar!) {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else {return}
                DispatchQueue.main.async {
                    self.gravatarImageView.image = UIImage(data: data)
                }
            }
        }
        
    }
    
    @IBAction func tapToMail(_ sender: UIButton) {
    }
    
    @IBAction func tapToMessage(_ sender: UIButton) {
    }
    
    @IBAction func tapToCall(_ sender: UIButton) {
    }
    @IBAction func tapToSave(_ sender: UIButton) {
        
        if !isValidEmail(email:self.emailTextInput.text!) && !isValidPhone(phone: self.phoneTextInput.text!){
            self.saveButton.isHidden = true
            self.editButton.isHidden = false
            self.firstNameTextInput.isUserInteractionEnabled = false
            self.lastNameTextInput.isUserInteractionEnabled = false
            self.emailTextInput.isUserInteractionEnabled = false
            self.firstNameTextInput.isUserInteractionEnabled = false
            self.profilPicker.isUserInteractionEnabled = false
        }
       
        //TODO: update avec l'api
    }
    @IBAction func tapToEdit(_ sender: UIButton) {
        
        self.saveButton.isHidden = false
        self.editButton.isHidden = true
        
        self.firstNameTextInput.isUserInteractionEnabled = true
        self.lastNameTextInput.isUserInteractionEnabled = true
        self.emailTextInput.isUserInteractionEnabled = true
        self.firstNameTextInput.isUserInteractionEnabled = true
        self.profilPicker.isUserInteractionEnabled = true
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

    let profils = ["Senior" ,"Famille" ,"Medecin"]
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
        if validEmail {
            validEmail = !email.contains("..")
        }
        return validEmail
    }
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^\\d{3}-\\d{3}-\\d{4}$"
        var validPhone = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        if validPhone {
            validPhone = !phone.contains("..")
        }
        return validPhone
    }
}
