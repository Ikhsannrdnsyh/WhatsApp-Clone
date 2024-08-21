//
//  ProfileTableViewController.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 21/08/24.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    //MARK: - Vars
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        setupUI()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //navigate to chat screen
        if indexPath.section == 1 {
            print("Navigate to chat screen")
        }
    }
    
    
    //MARK: - Setup UI
    
    private func setupUI(){
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        
        guard let user = self.user else { return }
        usernameLabel.text = user.username
        statusLabel.text = user.status
        
        if user.avatar != "" {
            FirebaseStorageHelper.downloadImage(url: user.avatar) { image in
                self.avatarImageView.image = image
            }
        }
    }
}
