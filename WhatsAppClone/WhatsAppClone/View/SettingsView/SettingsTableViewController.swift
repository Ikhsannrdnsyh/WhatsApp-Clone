//
//  SettingsTableViewController.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 13/08/24.
//

import Foundation
import UIKit
import FirebaseAuth


class SettingsTableViewController: UITableViewController{
    //MARK: - IBOutlet
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchUserInfo()
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "editProfileSegue", sender: self)
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func tellAFriendButtonTap(_ sender: Any) {
        print("button tell a friend")
    }
    @IBAction func logoutButtonTap(_ sender: Any) {
        FirebaseUserListener.shared.logoutUser{ error in
            if error == nil{
                let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginView")
                
                DispatchQueue.main.async{
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: - update UI
    private func fetchUserInfo(){
        if let user = User.currentUser {
            usernameLabel.text = user.username
            statusLabel.text = "Available"
        }
    }
}
