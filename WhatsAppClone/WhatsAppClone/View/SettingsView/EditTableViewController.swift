//
//  EditTableViewController.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 13/08/24.
//

import UIKit
import YPImagePicker


class EditTableViewController: UITableViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - Vars
    var picker: YPImagePicker?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        
        configureUserNameTextField()
        configureImagePicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserInfo()
    }
    //MARK: - IBAction
    
    @IBAction func editButtonTap(_ sender: Any) {
        showPicker()
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
    
    private func configureImagePicker(){
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.screens = [.library]
        config.library.maxNumberOfItems = 3
        
        picker = YPImagePicker(configuration: config)
    }
    
    private func showPicker(){
        guard let picker = picker else { return }
        
        picker.didFinishPicking { [unowned picker] items, canceled in
            if canceled {
                // cancel
            }
            
            if let photo = items.singlePhoto {
                DispatchQueue.main.async {
                    self.avatarImageView.image = photo.image
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
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
