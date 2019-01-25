//
//  AddContactViewController.swift
//  Familink
//
//  Created by formation12 on 23/01/2019.
//  Copyright © 2019 ti.punch. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    let profils = ["Senior","Famille","Medecin"]
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
    @IBOutlet weak var addContactIlmageView: UIImageView!
    @IBOutlet weak var firstNameTextLabel: UILabel!
    @IBOutlet weak var lastNameTextLabel: UILabel!
    @IBOutlet weak var phoneNumberTextLabel: UILabel!
    @IBOutlet weak var mailTextLabel: UILabel!
    @IBOutlet weak var profilPickerTextLabel: UILabel!
    @IBAction func addImageButton(_ sender: UIButton) {
    }
    @IBOutlet weak var addContactprofilPicker: UIPickerView!
    @IBAction func addContactButton(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addContactprofilPicker.delegate = self
        addContactprofilPicker.dataSource = self

        // Do any additional setup after loading the view.
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
