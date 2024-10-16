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
        //Setup UI
        setupRefreshControl()
        setupSearchbar()
        
//        createDummyUsers()
        fetchUsersData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
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
        
        let user = searchController.isActive ? filterUsers[indexPath.row] : allUsers[indexPath.row]
        navigateToProfileScreen(user)
        
    }
    
    //MARK: - setup UI
    private func setupRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = refreshControl
    }
    
    private func setupSearchbar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contact"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let refreshControl = self.refreshControl else { return }
        
        if refreshControl.isRefreshing{
            self.fetchUsersData()
            refreshControl.endRefreshing()
        }
    }
    
    //MARK: - Fetch Data
    private func fetchUsersData(){
        FirebaseUserListener.shared.downloadAllUsersFromFirestore { users in
            self.allUsers = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func filterUser(text: String){
        filterUsers = allUsers.filter({ (user) -> Bool in
            return user.username.lowercased().contains(text.lowercased())
        })
        tableView.reloadData()
    }
    
    //MARK: - Navigation
    private func navigateToProfileScreen(_ user: User){
        let profileView = ProfileViewController()
        profileView.viewModel = ProfileUIViewModel(user: user)
        self.navigationController?.pushViewController(profileView, animated: true)
    }
}

extension ContactsTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterUser(text: searchController.searchBar.text!)
    }
}
