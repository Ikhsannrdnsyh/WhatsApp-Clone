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
        messageInputBar.sendButton.title = ""
        
        //Init Buttons
        attachButton = {
            let button = InputBarButtonItem()
            button.image = UIImage(named: "plus")
            button.setSize(CGSize(width: 24.0, height: 24.0), animated: false)
            return button
        }()
        
        photoButton = {
            let button = InputBarButtonItem()
            button.image = UIImage(named: "camera")
            button.setSize(CGSize(width: 24.0, height: 24.0), animated: false)
            return button
        }()
        
        micButton = {
            let button = InputBarButtonItem()
            button.image = UIImage(named: "mic")
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
        
    }
    

}
