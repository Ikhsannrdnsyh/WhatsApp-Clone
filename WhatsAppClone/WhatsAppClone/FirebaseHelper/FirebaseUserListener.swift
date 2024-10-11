//
//  FirebaseUserListener.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 12/08/24.
//

import Foundation
import Firebase

class FirebaseUserListener{
    static let shared = FirebaseUserListener()
    
    private init() {}
    
    //MARK: - Login
    func loginUser(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        //call firebase function for authentcation (login)
        Auth.auth().signIn(withEmail: email, password: password){ authDataResult, error in
            // check for error
            if let e = error {
                completion(e, false)
                return
            }
            // get the auth data result
            //safely check with guard
            guard let user = authDataResult?.user else{
                completion(NSError(), false)
                return
            }
            
            // Download user data
            FirebaseUserListener.shared.donwloadUserFromFirestore(userId: user.uid, email: email)
            
            
            // Call completion
            completion(nil, user.isEmailVerified)
        }
    }
    
    
    //MARK: - Register
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        // Call firebase function for authentication (register)
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            // check for error
            if let e = error {
                completion(e)
                return
            }
            // get the auth data result
            //safely check with guard
            guard let user = authDataResult?.user else{
                completion(NSError())
                return
            }
            
            //send email verification
            self.sendEmailVerificationTo(user)
            
            // save user info to UserDefaults
            self.saveUser(email: email, uid: user.uid)
            
            completion(nil)
            
        }
    }
    //MARK: - Reset Password
    
    func resetPassword(email: String, completion: @escaping(_ error: Error?) -> Void){
        //Firebase Auth
        Auth.auth().sendPasswordReset(withEmail: email){ error in
            completion(error)
        }
    }
    
    //function for send email verification
    private func sendEmailVerificationTo(_ user: FirebaseAuth.User){
        user.sendEmailVerification{ error in
            if let e = error{
                print("Error sending email verification: ", e.localizedDescription)
            }else{
                print("success send email verification")
            }
        }
    }
    
    //function to save user to UserDefaults
    private func saveUser(email: String, uid: String){
        // create object of user
        let user = User(id: uid, username: email, email: email, status: "Available", avatar: "", firstName: "", lastName: "")
        
        //save user to userDefaults
        saveUserLocally(user)
        
        //save to Firestore
        saveUserToFirestore(user)
        
    }
    
    //function to save user to firestore
    func saveUserToFirestore(_ user: User){
        do{
            try FirebaseReference(.User).document(user.id).setData(from: user)
        }catch{
            print("Error save user to Firestore ", error.localizedDescription)
        }
    }
    
    //MARK: - Download
    
    func getUser(by userId: String, completion: @escaping(_ user: User?) -> Void){
        FirebaseReference(.User).document(userId).getDocument { snapshot, error in
            guard let document = snapshot else {
                print("No document found")
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            switch result {
            case .success(let userObj):
                if let user = userObj{
                    completion(user)
                }else{
                    print("No User found")
                    completion(nil)
                }
            case .failure(let error):
                completion(nil)
                print("Error encoding user data, ", error.localizedDescription)
            }
            
            
        }
    }
    
    func donwloadUserFromFirestore(userId: String, email: String? = nil){
        //call firebase function to download user data
        FirebaseReference(.User).document(userId).getDocument { snapshot, error in
            guard let document = snapshot else {
                print("No document found")
                return
            }
            
            //Dowload data
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObj):
                if let user = userObj{
                    // Save user data to UserDefaults
                    saveUserLocally(user.self)
                }else{
                    print("No User found")
                }
            case .failure(let error):
                print("Error encoding user data, ", error.localizedDescription)
            }
        }
        
    }
    
    func downloadAllUsersFromFirestore(completion: @escaping (_ allUsers: [User]) -> Void ){
        var users: [User] = []
        
        FirebaseReference(.User).limit(to: kLimitDownload).getDocuments { snapshot, error in
            guard let document = snapshot?.documents else {
                print("No documents in database")
                return
            }
            
            let allUsers = document.compactMap { querySnapshot in
                return try? querySnapshot.data(as: User.self)
            }
            
            for user in allUsers{
                if User.currentID != user.id {
                    users.append(user)
                }
            }
            completion(users)
        }
    }
    
    func downloadUsersFromFirestore(withIds: [String], completion: @escaping (_ allUsers: [User]) -> Void) {
        var users: [User] = []
        var count = 0
        
        
        for id in withIds {
            FirebaseReference(.User).document(id).getDocument { snapshot, error in
                guard let document = snapshot else {
                    print("no document found")
                    return
                }
                let user = try? document.data(as: User.self)
                users.append(user!)
                
                count += 1
                if count == withIds.count{
                    completion(users)
                }
            }
        }
    }
    
    //MARK: - LOgout
    func logoutUser(completion: @escaping (_ error: Error?) -> Void ){
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: kCurrentUser)
            UserDefaults.standard.synchronize()
            
            completion(nil)
            
        }catch let error as NSError{
            completion(error)
        }
    }
}
