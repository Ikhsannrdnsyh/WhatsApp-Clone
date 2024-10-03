//
//  MKSender.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 03/10/24.
//

import Foundation
import MessageKit

struct MKSender: SenderType, Equatable{
    var senderId: String
    var displayName: String
}
