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
        message: "Email invalide",
        preferredStyle: .alert
    )
    
    let alertPhone = UIAlertController(
        title: "Erreur sur le formulaire",
        message: "Téléphone invalide",
        preferredStyle: .alert
    )
    
    let alertDelete = UIAlertController(
        title: "Supprimer le contact",
        message: "Etes vous sur de supprimer le contact?",
        preferredStyle: .alert
    )
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
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
    
    var profile: String?
    var newGravatarUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alertPhone.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alertDelete.addAction(UIAlertAction(title: "OK", style: .default, handler: { (sender) in
            APIClient.instance.deleteContact(c: self.contact, onSucces: { (contactdelete) in
                print("Contact supprimé")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("deleteContact"), object: self)
                    self.navigationController?.popViewController(animated: true)
                }
            }) { (e) in
                if e == "Security token invalid or expired" {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(
                            title: "Session expiré",
                            message: "Veuillez-vous reconnecter pour accèder aux fonctionnalités",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (sender) in
                            let controller = UIStoryboard.init(
                                name: "Main",
                                bundle: nil).instantiateViewController(
                                    withIdentifier: "LoginViewController") as! LoginViewController
                            
                            self.navigationController?.show(controller, sender: self)
                        }))
                        self.present(alert, animated: true)
                    }
                }
            }
            
            
        }))
        alertDelete.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        profilPicker.delegate = self
        profilPicker.dataSource = self
        self.saveButton.isHidden = true
        self.editButton.isHidden = false
        self.editGravatar.isHidden = true
        self.firstNameTextInput.isUserInteractionEnabled = false
        self.lastNameTextInput.isUserInteractionEnabled = false
        self.phoneTextInput.isUserInteractionEnabled = false
        self.emailTextInput.isUserInteractionEnabled = false
        self.firstNameTextInput.isUserInteractionEnabled = false
        self.profilPicker.isUserInteractionEnabled = false
        
        
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
        
        /*let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipe.direction = UISwipeGestureRecognizer.Direction.down
        swipe.cancelsTouchesInView = false
        view.addGestureRecognizer(swipe)*/
    }
    /*@objc func dismissKeyboard() {
        view.endEditing(true)
    }*/
    
    
    @IBAction func tapToChangeImage(_ sender: UIButton) {
        
        let alert = UIAlertController(
            title: "Nouvel Image",
            message: "Entrez l'url de l'image souhaité :",
            preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "https://s.hs-data.com/bilder/spieler/gross/29566.jpg"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.imageUrl = textField.text!
            if let url = URL(string: self.imageUrl) {
                DispatchQueue.global().async {
                    guard let data = try? Data(contentsOf: url) else {return}
                    DispatchQueue.main.async {
                        let newImage = UIImage(data: data)
                        self.gravatarImageView.image = newImage
                        self.newGravatarUrl = textField.text!
                        print(self.newGravatarUrl ?? "https://s.hs-data.com/bilder/spieler/gross/29566.jpg")
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
    @IBAction func tapToDelete(_ sender: UIButton) {
        if(ConnectedClient.instance.isConnectedToNetwork()) {
             self.present(alertDelete, animated: true, completion: nil)
        } else {
            ConnectedClient.instance.errorConnectingAlert(view: self, handler: nil)
        }
    }
    
    @IBAction func tapToSave(_ sender: UIButton) {
        if(ConnectedClient.instance.isConnectedToNetwork()) {
            if !isValidEmail(email: self.emailTextInput.text!) {
                self.present(alert, animated: true)
            } else if (self.phoneTextInput.text?.count)! > 10 {
                self.present(alertPhone, animated: true)
            } else {
                self.saveButton.isHidden = true
                self.editButton.isHidden = false
                self.editGravatar.isHidden = true
                self.firstNameTextInput.isUserInteractionEnabled = false
                self.lastNameTextInput.isUserInteractionEnabled = false
                self.phoneTextInput.isUserInteractionEnabled = false
                self.emailTextInput.isUserInteractionEnabled = false
                self.firstNameTextInput.isUserInteractionEnabled = false
                self.profilPicker.isUserInteractionEnabled = false
                let contact = Contact(context: self.getContext()!)
                contact.firstName = self.firstNameTextInput.text
                contact.lastName = self.lastNameTextInput.text
                contact.email = self.emailTextInput.text
                contact.phone = self.phoneTextInput.text
                contact.profile = profile ?? self.contact.profile
                contact.gravatar = self.newGravatarUrl
                contact.id = self.contact.id
                contact.isFamilinkUser = self.contact.isFamilinkUser
                contact.isEmergencyUser = self.contact.isEmergencyUser
                
                print(contact)
                APIClient.instance.updateContact(c: contact, onSucces: { (contactUpdated) in
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name("updateContact"), object: self)
                        print("Contact modifié")
                    }
                }) { (e) in
                        if e == "Security token invalid or expired" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(
                                    title: "Session expiré",
                                    message: "Veuillez-vous reconnecter pour accèder aux fonctionnalités",
                                    preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (sender) in
                                    let controller = UIStoryboard.init(
                                        name: "Main",
                                        bundle: nil).instantiateViewController(
                                            withIdentifier: "LoginViewController") as! LoginViewController

                                    self.navigationController?.show(controller, sender: self)
                                }))
                                self.present(alert, animated: true)
                            }
                        }
                }
            }
        } else {
            self.saveButton.isHidden = true
            self.editButton.isHidden = false
            self.editGravatar.isHidden = true
            self.firstNameTextInput.isUserInteractionEnabled = false
            self.lastNameTextInput.isUserInteractionEnabled = false
            self.phoneTextInput.isUserInteractionEnabled = false
            self.emailTextInput.isUserInteractionEnabled = false
            self.firstNameTextInput.isUserInteractionEnabled = false
            self.profilPicker.isUserInteractionEnabled = false
            self.firstNameTextInput.text = self.contact.firstName
            self.lastNameTextInput.text = self.contact.lastName
            self.phoneTextInput.text = self.contact.phone
            self.emailTextInput.text = self.contact.email
            ConnectedClient.instance.errorConnectingAlert(view: self, handler: nil)
        }
    }
    
    @IBAction func tapToEdit(_ sender: UIButton) {
        
        if(ConnectedClient.instance.isConnectedToNetwork()) {
            self.saveButton.isHidden = false
            self.editButton.isHidden = true
            self.editGravatar.isHidden = false
            
            self.firstNameTextInput.isUserInteractionEnabled = true
            self.lastNameTextInput.isUserInteractionEnabled = true
            self.phoneTextInput.isUserInteractionEnabled = true
            self.emailTextInput.isUserInteractionEnabled = true
            self.firstNameTextInput.isUserInteractionEnabled = true
            self.profilPicker.isUserInteractionEnabled = true
        } else {
            ConnectedClient.instance.errorConnectingAlert(view: self, handler: nil)
        }
        
        // TODO: change UI<
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        profile = profils[row].uppercased()
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        var validEmail = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        if validEmail {
            validEmail = !email.contains("..")
        }
        return validEmail
    }
    func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
