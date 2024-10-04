//
//  IncomingMessageHelper.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 04/10/24.
//

import Foundation
import MessageKit

class IncomingMessageHelper {
    var messageVC: MessagesViewController
    
    init(messageVC: MessagesViewController) {
        self.messageVC = messageVC
    }
    
    // MARK: - Create message
    func createMessage(localMessage: LocalMessage) -> MKMessage? {
        let mkMessage = MKMessage(message: localMessage)
        
        
        return mkMessage
    }
}
