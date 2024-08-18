//
//  ContactsTableViewController.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 18/08/24.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    //MARK: - Vars
    
    var allUsers: [User] = []
    var filterUsers: [User] = []
    
    let searchController = UISearchController(searchResultsController: nil)

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createDummyUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filterUsers.count : allUsers.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactsTableViewCell
        let user = searchController.isActive ? filterUsers[indexPath.row] : allUsers[indexPath.row]
        cell.configure(user: user)

        return cell
    }
    
    //MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //TODO: Show user details
    }

}
