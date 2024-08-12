//
//  LoginViewController.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 12/08/24.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - IBOutlets
    //Label
    @IBOutlet weak var registerLabel: UILabel!
    
    //Textfield
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    //Button
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonTap(_ sender: Any) {
        print("loginButtonTap")
    }
    
    @IBAction func forgotPasswordButtonTp(_ sender: Any) {
        print("forgotPassword")
    }
    
    @IBAction func registerButtonTap(_ sender: Any) {
        print("registerButton")
    }
}

