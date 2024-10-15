//
//  MessagesDataSource.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 03/10/24.
//

import Foundation
import MessageKit

extension ChatViewController: MessagesDataSource{
    func currentSender() -> any MessageKit.SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    func textCell(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        let cell = messagesCollectionView.dequeueReusableCell(CustomTextChatView.self, for: indexPath)
        cell.configure(with: mkMessages[indexPath.section], at: indexPath, and: messagesCollectionView)
        
        return cell
    }
    
//    func photoCell(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
//        
//    }
    
}
