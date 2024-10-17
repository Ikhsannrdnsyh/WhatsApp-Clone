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
    var viewModel: ProfileViewModel!
    
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
            viewModel.navigateToChatVC { chatVC in
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
    
    
    //MARK: - Setup UI
    private func setupUI(){
        usernameLabel.text = viewModel.userName
        statusLabel.text = viewModel.status
        
        viewModel.fetchAvatarImage { avatar in
            self.avatarImageView.image = avatar
        }
    }
}
