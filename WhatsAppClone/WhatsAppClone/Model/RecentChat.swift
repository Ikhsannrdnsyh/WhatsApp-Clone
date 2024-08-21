//
//  RecentChat.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 21/08/24.
//

import Foundation
import FirebaseFirestore

struct RecentChat: Codable {
    var id = ""
    var chatRoom = ""
    var senderID = ""
    var senderName = ""
    var receiverID = ""
    var receiverName = ""
    @ServerTimestamp var date = Date()
    var lastMessage = ""
    var unreadCounter = 0
    var avatar = ""
    
}
