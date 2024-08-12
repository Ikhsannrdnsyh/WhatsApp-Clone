//
//  User.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 12/08/24.
//

import Foundation
import Firebase

struct User: Codable, Equatable{
    var id = ""
    var username: String
    var email: String
    var pushId = ""
    var avatar = ""
    var firstName: String?
    var lastName: String?
    
    //MARK: - Helpers
    static var currentID: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let UserDict = UserDefaults.standard.data(forKey: kCurrentUser){
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: UserDict)
                    return userObject
                } catch{
                    print("Failed to decode userObject", error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    static func == (lhs: User, rhs: User) -> Bool{
        lhs.id == rhs.id
    }
}
