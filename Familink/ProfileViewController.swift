//
//  ProfileViewController.swift
//  Familink
//
//  Created by formation12 on 23/01/2019.
//  Copyright © 2019 ti.punch. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
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
    
  
        // Do any additional setup after loading the view.
    }
    @IBAction func tapToSave(_ sender: UIButton) {
        self.saveButton.isHidden = true
        self.editButton.isHidden = false
    } //TODO: update avec l'api
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

}
