//
//  MessagesViewController.swift
//  WYJKitDemo
//
//  Created by PZ-IMAC-1 on 2021/8/27.
//  Copyright © 2021 祎. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class MessagesViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()
    var myBubble: JSQMessagesBubbleImage?
    var otherBubble: JSQMessagesBubbleImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = "123"
        senderDisplayName = "456"
        createBuble()
    }
    func createBuble() {
        let factory = JSQMessagesBubbleImageFactory()
        myBubble = factory?.outgoingMessagesBubbleImage(with: .blue)
        otherBubble = factory?.incomingMessagesBubbleImage(with: .red)
        
        let button = UIButton().yi.then({
            $0.yi.title("发送")
            $0.yi.color(.red)
        })
        
        inputToolbar.contentView.rightBarButtonItem = button
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        WYJSystem().invokeSystemPhoto { img in
//            guard let msg = JSQMessage.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text) else { return }
//            messages.append(msg)
//            let imgss = JSQMessagesAvatarImage(avatarImage: img, highlightedImage: img, placeholderImage: img)
//            messages.append(imgss)
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let msg = messages[indexPath.row]
        if msg.senderDisplayName() == "456" {
            return myBubble
        }
        return otherBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImage.init(avatarImage: UIImage(), highlightedImage: UIImage(), placeholderImage: UIImage())
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        guard let msg = JSQMessage.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text) else { return }
        messages.append(msg)
        collectionView.reloadData()
    }
    
}
