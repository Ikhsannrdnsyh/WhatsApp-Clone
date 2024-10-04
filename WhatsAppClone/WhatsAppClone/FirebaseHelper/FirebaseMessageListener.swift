//
//  FirebaseMessageListener.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 04/10/24.
//

import Foundation
import Firebase

class FirebaseMessageListener {
    static let shared = FirebaseMessageListener()
    
    private init(){}
    
    //MARK: - Save, update, delete message
    
    func saveMessage(_ message: LocalMessage, memberId: String){
        do{
            try FirebaseReference(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        }catch{
            print("Error when saving Message to Firebase ", error.localizedDescription)
        }
    }
}
