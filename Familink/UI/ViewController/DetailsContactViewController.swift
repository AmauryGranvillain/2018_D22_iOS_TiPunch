//
//  DetailsContactViewController.swift
//  Familink
//
//  Created by formation12 on 23/01/2019.
//  Copyright © 2019 ti.punch. All rights reserved.
//

import UIKit
import CoreData

class DetailsContactViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var contact: Contact = Contact()
    var imageUrl = ""
    let alert = UIAlertController(
        title: "Erreur sur le formulaire",
        message: "Informations invalide",
        preferredStyle: .alert
    )
    
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
    @IBOutlet weak var editGravatar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        profilPicker.delegate = self
        profilPicker.dataSource = self
        self.saveButton.isHidden = true
        self.editButton.isHidden = false
        self.editGravatar.isHidden = true
        self.contact = Contact(context: self.getContext()!)
        self.imageUrl = contact.gravatar!
        
    }
    
    @IBAction func tapToChangeImage(_ sender: UIButton) {
        
        let alert = UIAlertController(
            title: "Nouvel Image",
            message: "Entrez l'url de l'image souhaité :",
            preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "https://s.hs-data.com/bilder/spieler/gross/29566.jpg"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            self.imageUrl = textField.text!
            if let url = URL(string: self.imageUrl) {
                DispatchQueue.global().async {
                    guard let data = try? Data(contentsOf: url) else {return}
                    DispatchQueue.main.async {
                        let newImage = UIImage(data: data)
                        self.gravatarImageView.image = newImage
                    }
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func tapToMail(_ sender: UIButton) {
    }
    
    @IBAction func tapToMessage(_ sender: UIButton) {
    }
    
    @IBAction func tapToCall(_ sender: UIButton) {
    }
    @IBAction func tapToSave(_ sender: UIButton) {
        
        if !isValidEmail(email:self.emailTextInput.text!) || !isValidPhone(phone: self.phoneTextInput.text!){
            self.present(alert, animated: true)
        }
        else {
            self.saveButton.isHidden = true
            self.editButton.isHidden = false
            self.editGravatar.isHidden = true
            self.firstNameTextInput.isUserInteractionEnabled = false
            self.lastNameTextInput.isUserInteractionEnabled = false
            self.emailTextInput.isUserInteractionEnabled = false
            self.firstNameTextInput.isUserInteractionEnabled = false
            self.profilPicker.isUserInteractionEnabled = false
            let contact = Contact(context: self.getContext()!)
            contact.firstName = self.firstNameTextInput.text
            contact.lastName = self.firstNameTextInput.text
            contact.email = self.firstNameTextInput.text
            contact.phone = self.firstNameTextInput.text
            contact.profile = self.profilPickerTextLabel.text
            
            APIClient.instance.updateContact(c: contact, onSucces: { (contactUpdated) in
            }) { (e) in
                print("Das Problem")
            }
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
    func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
}

