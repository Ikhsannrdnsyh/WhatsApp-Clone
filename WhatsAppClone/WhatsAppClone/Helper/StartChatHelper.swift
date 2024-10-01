//
//  StartChatHelper.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 01/10/24.
//

import Foundation

class StartChatHelper{
    //MARK: - Start Chat
    func startChat(user1: User, user2: User) -> String {
        let chatRoomId = getChatRoomId(user1ID: user1.id, user2ID: user2.id)
        
        //create recent items
        createRecentChatItems(chatRoomID: chatRoomId, users: [user1, user2])
        
        return chatRoomId
    }
    
    func createRecentChatItems(chatRoomID: String, users: [User]){
        // Check user have a recent chat
        FirebaseReference(.Recent).whereField(kChatRoomId, isEqualTo: chatRoomID).getDocuments { snaptshot, error in
            
        }
    }
    
    func getChatRoomId(user1ID :String, user2ID: String)->String{
        var chatRoomId = ""
        
        let value = user1ID.compare(user2ID).rawValue
        chatRoomId = value < 0 ? (user1ID + user2ID) : (user2ID + user1ID)
        
        return chatRoomId
    }
}
