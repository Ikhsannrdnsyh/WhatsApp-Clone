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
    var newChatListener: ListenerRegistration!
    
    private init(){}
    
    //MARK: Chat listener
    func listenForNewChat(_ documentId: String, collectionId: String, lastMessageDate: Date){
        newChatListener = FirebaseReference(.Message).document(documentId).collection(collectionId).whereField(kDate, isGreaterThan: lastMessageDate).addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot else { return }
            
            for change in snapshot.documentChanges {
                if change.type == .added{
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch result{
                    case .success(let message):
                        if let message = message {
                            if message.senderId != User.currentID{
                                DBManager.shared.saveToRealm(message)
                            }
                        } else {
                            print("Messages doesn't exist")
                        }
                    case .failure(let error):
                        print("Error decoding message: \(error.localizedDescription)")
                    }
                }
            }
        })
    }
    
    //MARK: - Save, update, delete message
    
    func saveMessage(_ message: LocalMessage, memberId: String){
        do{
            try FirebaseReference(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        }catch{
            print("Error when saving Message to Firebase ", error.localizedDescription)
        }
    }
    
    func updateMessage(_ message: LocalMessage, memberIds: [String]){
        let value = [kStatus : kRead, kReadDate : Date()] as [String : Any]
        
        for id in memberIds {
            FirebaseReference(.Message).document(id).collection(message.chatRoomId).document(message.id).updateData(value)
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
