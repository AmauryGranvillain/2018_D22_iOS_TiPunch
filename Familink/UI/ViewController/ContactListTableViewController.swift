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

    @IBOutlet weak var searchBar: UISearchBar!
    var contacts: [Contact] = []
    var filterContacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector (loadContactList),
            name: Notification.Name("login"), object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector (loadContactList),
            name: Notification.Name("addContact"), object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector (loadContactList),
            name: Notification.Name("deleteContact"), object: nil)
        
        self.searchBar.delegate = self
        
        tableView.register(UINib(
            nibName: "ContactListTableViewCell",
            bundle: nil),
            forCellReuseIdentifier: "ContactListTableViewCell")
        
        
    }
    
    @objc func loadContactList() {
        APIClient.instance.getAllContact(onSucces: { (contactsData) in
            self.contacts = contactsData
            self.filterContacts = self.contacts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (e) in
            print(e)
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
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
