//
//  ChatViewController.swift
//  WhatsAppClone
//
//  Created by Mochamad Ikhsan Nurdiansyah on 03/10/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    //MARK: - Vars
    
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    private var recipientAvatar = ""
    
    private var refreshController: UIRefreshControl = UIRefreshControl()
    
    //MARK: - Input bar vars
    private var attachButton: InputBarButtonItem!
    private var photoButton: InputBarButtonItem!
    private var micButton: InputBarButtonItem!
    
    
    
    //MARK: -
    let currentUser = MKSender(senderId: User.currentID, displayName: User.currentUser!.username)
    var mkMessages: [MKMessage] = []
    
    


   
    //MARK: - Inits
    
    init(chatId: String = "", recipientId: String = "", recipientName: String = "", recipientAvatar: String = "") {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
        self.recipientAvatar = recipientAvatar
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Config
        
        configureMessageCollectionView()
        configureMessageInputBar()
    }
    
    //MARK: -Config UI
    private func configureMessageCollectionView(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        messagesCollectionView.refreshControl = refreshController
    }
    
    private func configureMessageInputBar(){
        messageInputBar.delegate = self
        //messageInputBar.sendButton.title = ""
        
        // Text view
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.inputTextView.backgroundColor = UIColor.white
        messageInputBar.inputTextView.textColor = UIColor.black
        messageInputBar.inputTextView.layer.cornerRadius = 18
        messageInputBar.inputTextView.layer.borderWidth = 0.5
        messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        
        //Init Buttons
        attachButton = {
            let button = InputBarButtonItem()
            button.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            button.tintColor = UIColor.systemBlue
            button.setSize(CGSize(width: 24.0, height: 24.0), animated: false)
            return button
        }()
        
        photoButton = {
            let button = InputBarButtonItem()
            button.image = UIImage(systemName: "camera", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            button.tintColor = UIColor.systemBlue
            button.setSize(CGSize(width: 24.0, height: 24.0), animated: false)
            return button
        }()
        
        micButton = {
            let button = InputBarButtonItem()
            button.image = UIImage(systemName: "mic", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            button.tintColor = UIColor.systemBlue
            button.setSize(CGSize(width: 24.0, height: 24.0), animated: false)
            return button
        }()
        
        //On Button Tap
        attachButton.onTouchUpInside { item in
            print("attach")
        }
        
        photoButton.onTouchUpInside { item in
            print("photo")
        }
        
        micButton.onTouchUpInside { item in
            print("mic")
        }
        
        //set button
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 24, animated: false)
//        messageInputBar.setStackViewItems([photoButton], forStack: .right, animated: false)
//        messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
        
    }
    
    //MARK: - actions
    func sendMessage(text: String?, photo: UIImage?, video: String?, audio: String?, audioDuration: Float = 0.0){
        OutgoingMessageHelper.send(chatId: chatId, text: text, photo: photo, video: video, audio: audio, memberIds: [User.currentID, recipientId])
    }
}
