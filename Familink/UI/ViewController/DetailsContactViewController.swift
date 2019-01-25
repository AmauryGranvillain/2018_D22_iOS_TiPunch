//
//  DetailsContactViewController.swift
//  Familink
//
//  Created by formation12 on 23/01/2019.
//  Copyright © 2019 ti.punch. All rights reserved.
//

import UIKit
import CoreData
import MessageUI


class DetailsContactViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
    

    
    

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
     var contact: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilPicker.delegate = self
        profilPicker.dataSource = self
        self.saveButton.isHidden = true
        self.editButton.isHidden = false
       
        self.firstNameTextInput.text = contact.firstName
        self.lastNameTextInput.text = contact.lastName
        self.phoneTextInput.text = contact.phone
        self.emailTextInput.text = contact.email
        if let url = URL(string: contact.gravatar!) {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else {return}
                DispatchQueue.main.async {
                    self.gravatarImageView.image = UIImage(data: data)
                }
            }
        }
        
         self.gravatarImageView.transform = CGAffineTransform.init(scaleX: 0, y:0 )
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration:-1, animations: {
            self.gravatarImageView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        })
        
    }
    
    @IBAction func tapToMail(_ sender: UIButton) {
        
        if MFMailComposeViewController.canSendMail() {
        let message:String  = "Changes in mail composer ios 11"
        let composePicker = MFMailComposeViewController()
        composePicker.mailComposeDelegate = self
            composePicker.delegate = self as! UINavigationControllerDelegate
        composePicker.setToRecipients(["example@gmail.com"])
        composePicker.setSubject("Testing Email")
        composePicker.setMessageBody(message, isHTML: false)
        self.present(composePicker, animated: true, completion: nil)
    } else {
        self .showErrorMessage()
        }
    }
    func showErrorMessage() {
        let alertMessage = UIAlertController(title: "could not sent email", message: "check if your device have email support!", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title:"Okay", style: UIAlertAction.Style.default, handler: nil)
        alertMessage.addAction(action)
        self.present(alertMessage, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            break
        }
        self.dismiss(animated: true, completion: nil)
      
    }
    
    @IBAction func tapToMessage(_ sender: UIButton) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        composeVC.recipients = ["0641382323"]
        composeVC.body = "Hola Chico"
        
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Impossible d'envoyer un message.")
        }
    }
    
    @IBAction func tapToCall(_ sender: UIButton) {
        
        guard let numberString = contact.phone, let url =
            URL(string:"telprompt://\(numberString)") else {
            return
        }
        UIApplication.shared.open(url)
        
        /*if let url = URL(string: "tel://0641382323") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }*/
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    @IBAction func tapToSave(_ sender: UIButton) {
        self.saveButton.isHidden = true
        self.editButton.isHidden = false
        
        //TODO: update avec l'api
    }
    @IBAction func tapToEdit(_ sender: UIButton) {
        
        self.saveButton.isHidden = false
        self.editButton.isHidden = true
        
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
    func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
}
