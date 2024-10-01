//
//  RecentChatTableViewController.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 01/10/24.
//

import UIKit

class RecentChatTableViewController: UITableViewController, UISearchResultsUpdating {
    
    
    
    //MARK: - Vars
    
    var allRecentChats: [RecentChat] = []
    var filteredRecentChats: [RecentChat] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
        
        setupRefreshControl()
        setupSearchbar()
        fecthRecentChat()
        
        
    }
    
    //MARK: - setup UI
    private func setupRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = refreshControl
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let refreshControl = self.refreshControl else { return }
        
        if refreshControl.isRefreshing{
            self.fecthRecentChat()
            refreshControl.endRefreshing()
        }
    }
    
    private func setupSearchbar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentChatCell", for: indexPath) as! RecentChatTableViewCell
        let recentChat = searchController.isActive ? filteredRecentChats[indexPath.row] : allRecentChats[indexPath.row]
        cell.configure(recent: recentChat)

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredRecentChats.count : allRecentChats.count
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recentChat = searchController.isActive ? filteredRecentChats[indexPath.row] : allRecentChats[indexPath.row]
        
        //update counter page
        FirebaseRecentChatListener.shared.clearUnreadCounter(recentChat: recentChat)
        
        //navigate to chat room
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let recentChat = searchController.isActive ? filteredRecentChats[indexPath.row] : allRecentChats[indexPath.row]
            FirebaseRecentChatListener.shared.delete(recentChat: recentChat)
            searchController.isActive ? filteredRecentChats.remove(at: indexPath.row) : allRecentChats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    //MARK: - Private Func
    
    private func fecthRecentChat(){
        FirebaseRecentChatListener.shared.downloadRecentChatsFromFirestore { recentChats in
            self.allRecentChats = recentChats
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }

    

}
