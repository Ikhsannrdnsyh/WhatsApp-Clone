//
//  FirebaseRecentChatListener.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 01/10/24.
//

import Foundation

class FirebaseRecentChatListener{
    static let shared = FirebaseRecentChatListener()
    
    private init() {}
    
    func saveRecentChat(_ recentChat: RecentChat){
        do{
            try FirebaseReference(.Recent).document(recentChat.id).setData(from: recentChat)
        } catch{
            print("Error save recent chat ", error.localizedDescription)
        }
    }
}
