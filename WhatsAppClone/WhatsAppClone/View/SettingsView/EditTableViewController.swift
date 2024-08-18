//
//  EditTableViewController.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 13/08/24.
//

import UIKit



class EditTableViewController: UITableViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        
        configureUserNameTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserInfo()
    }
    //MARK: - IBAction
    
    @IBAction func editButtonTap(_ sender: Any) {
        
    }
    
    //MARK: - Update UI
    
    private func fetchUserInfo(){
        if let user = User.currentUser {
            usernameTextField.text = user.username
            statusLabel.text = ""
            
            if user.avatar != ""{
                //set profile picture
                
            }
        }
    }
    
    private func configureUserNameTextField() {
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }

    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension EditTableViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            guard textField.text != "" else { return false }
            
            if var user = User.currentUser{
                user.username = textField.text!
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFirestore(user)
            }
        }
        
        textField.resignFirstResponder()
        return false
    }
}
