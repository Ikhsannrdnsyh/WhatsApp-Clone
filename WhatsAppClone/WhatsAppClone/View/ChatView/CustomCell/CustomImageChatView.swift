//
//  CustomImageChatView.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 15/10/24.
//

import Foundation
import MessageKit
import UIKit

class CustomImageChatView: MessageContentCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rightBubble: UIView!
    @IBOutlet weak var leftBubble: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    //MARK: - Setup UI
    private func setupUI(){
        let nib = UINib(nibName: "CustomImageChatView", bundle: nil)
        
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        contentView.frame = self.messageContainerView.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.messageContainerView.addSubview(contentView)
    }
    
    override func configure(with message: any MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        
        guard let mkMessage = message as? MKMessage else { return }
        
        switch message.kind {
        case .photo(let photo):
            //set image
            imageView.image = photo.image
            infoLabel.text = self.getInfoText(mkMessage: mkMessage)
        default:
            break
        }
        
        if (messagesCollectionView.messagesDataSource?.isFromCurrentSender(message: message) ?? true){
            //Outgoing message
            leftBubble.isHidden = true
            rightBubble.isHidden = false
            customView.backgroundColor = UIColor(named: "chat_outgoing")
            leftBubble.backgroundColor = UIColor(named: "chat_outgoing")
            rightBubble.backgroundColor = UIColor(named: "chat_outgoing")
        }else{
            //Incoming message
            leftBubble.isHidden = false
            rightBubble.isHidden = true
            customView.backgroundColor = UIColor(named: "chat_incoming")
            leftBubble.backgroundColor = UIColor(named: "chat_incoming")
            rightBubble.backgroundColor = UIColor(named: "chat_incoming")
        }
    }
    
    private func getInfoText(mkMessage: MKMessage) -> String {
        if mkMessage.mkSender.senderId == User.currentID {
            if mkMessage.status == kSend {
                return "\(mkMessage.sentDate.time()) . Sent"
            }
            
            if mkMessage.status == kRead {
                return "\(mkMessage.readDate.time()) . Read"
            }
        }
        return mkMessage.readDate.time()
    }
    
    
}
