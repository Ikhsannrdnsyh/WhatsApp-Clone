//
//  StartChatHelper.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 01/10/24.
//

import Foundation
import Firebase

class StartChatHelper{
    static let shared = StartChatHelper()
    
    private init(){}
    
    //MARK: - Start Chat
    func startChat(user1: User, user2: User) -> String {
        let chatRoomId = getChatRoomId(user1ID: user1.id, user2ID: user2.id)
        
        //create recent items
        createRecentChatItems(chatRoomId: chatRoomId, users: [user1, user2])
        
        return chatRoomId
    }
    
    func restartChat(chatRoomId: String, memberIds: [String]){
        FirebaseUserListener.shared.downloadUsersFromFirestore(withIds: memberIds) { users in
            if users.count > 0 {
                StartChatHelper.shared.createRecentChatItems(chatRoomId: chatRoomId, users: users)
            }
        }
    }
    
    func createRecentChatItems(chatRoomId: String, users: [User]){
        guard !users.isEmpty else { return }
        
        var memberIdsToCreateRecentChat = [users.first!.id, users.last!.id]
        
        // Check user have a recent chat
        FirebaseReference(.Recent).whereField(kChatRoomId, isEqualTo: chatRoomId).getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            if !snapshot.isEmpty {
                //remove user who has recent chat
                memberIdsToCreateRecentChat = self.removeuserWhoHasRecentChat(snapshot: snapshot, memberIds: memberIdsToCreateRecentChat)
            }
            
            guard let currentUser = User.currentUser else { return }
            
            for id in memberIdsToCreateRecentChat {
                let senderUser = id == currentUser.id ? currentUser : self.getReceiverUser(users: users)
                
                let receiverUser = id == currentUser.id ? self.getReceiverUser(users: users) : currentUser
                
                let recentChat = RecentChat(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.username, receiverID: receiverUser.id, receiverName: receiverUser.username, date: Date(), lastMessage: "", unreadCounter: 0, avatar: receiverUser.avatar)
                
                //Store to Firebase
                FirebaseRecentChatListener.shared.saveRecentChat(recentChat)
            }
        }
    }
    
    func getChatRoomId(user1ID :String, user2ID: String)->String{
        var chatRoomId = ""
        
        let value = user1ID.compare(user2ID).rawValue
        chatRoomId = value < 0 ? (user1ID + user2ID) : (user2ID + user1ID)
        
        return chatRoomId
    }
    
    func removeuserWhoHasRecentChat(snapshot: QuerySnapshot, memberIds: [String]) -> [String]{
        var memberIdsToCreateRecentChat = memberIds
        
        for data in snapshot.documents {
            let currentRecent = data.data() as Dictionary
            
            if let currentUserId = currentRecent[kSenderId]{
                let userId = currentUserId as! String
                
                if memberIdsToCreateRecentChat.contains(userId) {
                    let idx = memberIdsToCreateRecentChat.firstIndex(of: userId)!
                    memberIdsToCreateRecentChat.remove(at: idx)
                }
            }
        }
        
        return memberIdsToCreateRecentChat
    }
    
    func getReceiverUser(users: [User]) -> User {
        var allUsers = users
        
        guard let currentUser = User.currentUser else { return allUsers.first! }
        
        allUsers.remove(at: allUsers.firstIndex(of: currentUser)!)
        
        return allUsers.first!
    }
}
