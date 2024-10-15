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
        
        // phoot message type
        if let photo = photo{
            sendPictureMessage(message: message, photo: photo, memberIDs: memberIds)
        }
        
        if let audio = audio{
            print("Test Duration \(audioDuration)")
        }
        
        FirebaseRecentChatListener.shared.updateRecentChat(chatRoomId: chatId, lastMessage: message.message)
    }
    
    class func sendMessage(message: LocalMessage, memberIds: [String]){
        //save message to Realm
        DBManager.shared.saveToRealm(message)
        
        //send message/ save to firebase
        for id in memberIds {
            FirebaseMessageListener.shared.saveMessage(message, memberId: id)
        }
    }
}

func sendTextMessage(message: LocalMessage, text: String, memberIds: [String]){
    message.message = text
    message.type = kText
    OutgoingMessageHelper.sendMessage(message: message, memberIds: memberIds)
}

func sendPictureMessage(message: LocalMessage, photo: UIImage, memberIDs: [String]){
    message.message = "Picture message"
    message.type = kPhoto
    
    //get file
    let fileName = Date().stringDate()
    let fileDir = "MediaMessages/Photo/" + "\(message.chatRoomId)/" + "_\(fileName).jpg"
    
    //Upload file
    FirebaseStorageHelper.saveFileToLocal(file: photo.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)
    FirebaseStorageHelper.uploadImage(photo, directory: fileDir) { imageLink in
        if let url = imageLink {
            message.photoUrl = url
            OutgoingMessageHelper.sendMessage(message: message, memberIds: memberIDs)
        }
    }
    
    
}
