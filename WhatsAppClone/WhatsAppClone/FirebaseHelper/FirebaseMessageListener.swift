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
    
    //MARK: - Fetch old message
    func fetchOldMessage(_ documentId: String, collectionId: String){
        FirebaseReference(.Message).document(documentId).collection(collectionId).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No document found")
                return
            }
            
            var messages = documents.compactMap { snapshot -> LocalMessage? in
                return try? snapshot.data(as: LocalMessage.self)
            }
            
            messages.sort(by: { $0.date < $1.date })
            for message in messages{
                DBManager.shared.saveToRealm(message)
            }
        }
    }
}
