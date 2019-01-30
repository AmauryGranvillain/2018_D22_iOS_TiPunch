//
//  ContactListTableViewController.swift
//  Familink
//
//  Created by formation12 on 23/01/2019.
//  Copyright © 2019 ti.punch. All rights reserved.
//

import UIKit
import CoreData


class ContactListTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var filterAllButton: UIButton!
    @IBOutlet weak var filterFamilyButton: UIButton!
    @IBOutlet weak var filterDoctorButton: UIButton!
    @IBOutlet weak var filterSeniorButton: UIButton!
    @IBOutlet weak var filterUrgencyButton: UIButton!
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var searchBar: UISearchBar!
    var contacts: [Contact] = []
    var filterContacts: [Contact] = []
    
    @IBAction func tapOnProfileUser(_ sender: UIBarButtonItem) {
        if(ConnectedClient.instance.isConnectedToNetwork()) {
            let controller = UIStoryboard.init(
                name: "Main",
                bundle: nil).instantiateViewController(
                    withIdentifier: "ProfileViewController") as! ProfileViewController
            
            self.show(controller, sender: self)
        } else {
            ConnectedClient.instance.errorConnectingAlert(view: self, handler: nil)
        }
    }
    @IBAction func tapOnAddContact(_ sender: UIBarButtonItem) {
        if(ConnectedClient.instance.isConnectedToNetwork()) {
            let controller = UIStoryboard.init(
                name: "Main",
                bundle: nil).instantiateViewController(
                    withIdentifier: "AddContactViewController") as! AddContactViewController
            
            self.show(controller, sender: self)
        } else {
            ConnectedClient.instance.errorConnectingAlert(view: self, handler: nil)
        }
    }
    lazy var reloadControl: UIRefreshControl = {
        let reloadControl = UIRefreshControl()
        reloadControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        reloadControl.tintColor = UIColor(red: 0.38, green: 0.55, blue: 0.21, alpha: 1.0)
        reloadControl.attributedTitle = NSAttributedString(string: "Rechargement de la liste ...")
        return reloadControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.reloadControl)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector (loadContactListFromAPI),
            name: Notification.Name("login"), object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector (loadContactListFromAPI),
            name: Notification.Name("addContact"), object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector (loadContactListFromCoreData),
            name: Notification.Name("offline"), object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector (loadContactListFromAPI),
            name: Notification.Name("deleteContact"), object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector (loadContactListFromAPI),
            name: Notification.Name("updateContact"), object: nil)
        

        
        self.searchBar.delegate = self
        
        tableView.register(UINib(
            nibName: "ContactListTableViewCell",
            bundle: nil),
            forCellReuseIdentifier: "ContactListTableViewCell")
        
        
    }
    
    @objc func loadContactListFromAPI() {

        APIClient.instance.getAllContact(onSucces: { (contactsData) in
            self.contacts = contactsData
            self.filterContacts = self.contacts
            self.addContactsToCoreData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
    @objc func loadContactListFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        self.contacts = CoreDataClient.instance.getContacts()
        filterContacts = contacts
        self.tableView.reloadData()
    }
    
    func addContactsToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let contactsFromCoreData = CoreDataClient.instance.getContacts()
        DispatchQueue.main.async {
            for contact in contactsFromCoreData {
                context.delete(contact)
            }
            for contact in self.contacts {
                context.insert(contact)
            }
            try? context.save()
        }
    }

    // MARK: - Table view data source
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filterContacts = contacts
        } else {
            filterContacts.removeAll()
            for contact in contacts {
                if(contact.firstName?.lowercased().starts(with: searchText.lowercased()))!
                    || (contact.lastName?.lowercased().starts(with: searchText.lowercased()))!{
                    filterContacts.append(contact)
                }
            }
        }
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.filterContacts.count
    }
    
     @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadContactListFromAPI()
        reloadControl.endRefreshing()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ContactListTableViewCell",
            for: indexPath) as! ContactListTableViewCell

        let contactIndex = self.filterContacts[indexPath.row]
        cell.contactNameLabel.text = contactIndex.firstName! + " " + contactIndex.lastName!
        
        cell.contactProfileLabel.text = contactIndex.profile
        
        guard let imageUrl = contactIndex.gravatar else {return cell}
        if let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else {return}
                DispatchQueue.main.async {
                    cell.gravatarContactImageView.image = UIImage(data: data)
                }
            }
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard.init(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: "DetailsContactViewController") as! DetailsContactViewController
        
        controller.contact = self.filterContacts[indexPath.row]
        
        self.show(controller, sender: self)
    }
    
    @IBAction func selectAllContact(_ sender: Any) {
        filterContacts.removeAll()
        filterContacts = contacts
        self.tableView.reloadData()
    }
    @IBAction func selectFamilyContact(_ sender: Any) {
        filterContacts.removeAll()
        filterContacts = contacts.filter({ (contact) -> Bool in
            return contact.profile == "FAMILLE"
        })
        self.tableView.reloadData()
    }
    @IBAction func selectUrgencyContact(_ sender: Any) {
        filterContacts.removeAll()
        filterContacts = contacts.filter({ (contact) -> Bool in
            return contact.isEmergencyUser == true
        })
        self.tableView.reloadData()
    }
    @IBAction func selectDoctorContact(_ sender: Any) {
        filterContacts.removeAll()
        filterContacts = contacts.filter({ (contact) -> Bool in
            return contact.profile == "MEDECIN"
        })
        self.tableView.reloadData()
    }
    @IBAction func selectSeniorContact(_ sender: Any) {
        filterContacts.removeAll()
        filterContacts = contacts.filter({ (contact) -> Bool in
            return contact.profile == "SENIOR"
        })
        self.tableView.reloadData()
    }
}
