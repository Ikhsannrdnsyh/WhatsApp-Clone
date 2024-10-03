//
//  OutgoingMessageHelper.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 03/10/24.
//

import Foundation
import UIKit

class OutgoingMessageHelper{
    class func send(chatId: String, text: String?, photo: UIImage?, video: String?, audio: String?, audioDuration: Float = 0.0, memberIds: [String]){
        guard let currentUser = User.currentUser else { return }
        
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderInitial = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSend
        
        // Text message type
        if text != nil{
            sendTextMessage(message: message, text: text ?? "", memberIds: memberIds)
        }
    }
    
    class func sendMessage(message: LocalMessage, memberIds: [String]){
        //save message to Realm
        print("send Message \(message)")
        //send message/ save to firebase
    }
}

func sendTextMessage(message: LocalMessage, text: String, memberIds: [String]){
    message.message = text
    message.type = kText
    OutgoingMessageHelper.sendMessage(message: message, memberIds: memberIds)
}
