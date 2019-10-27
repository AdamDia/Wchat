//
//  ChatViewController.swift
//  my first app
//
//  Created by Adam Essam on 8/29/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import ProgressHUD
import IQAudioRecorderController //for audio msgs
import IDMPhotoBrowser //to show images in chat
import AVFoundation //AV both to display video msgs
import AVKit
import FirebaseFirestore //to get all of our msgs from firestore



class ChatViewController: JSQMessagesViewController {
    
//color dah JSQ bytwfro bas el ragel by2ol eno el Blue feh moshkela m3 syaset apple when uploading it on the app store
    var outgingBubble = JSQMessagesBubbleImageFactory()?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    
    var incomingBubble = JSQMessagesBubbleImageFactory()?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())

    override func viewDidLoad() {
        super.viewDidLoad()

        //el etnen dol lazem 34an el implemet bta3 el JSQMessagesViewController other wise our JSQ will crash
        
        self.senderId = FUser.currentId()
        self.senderDisplayName = FUser.currentUser()!.firstname
        
        //MARK: custom send button
        
        self.inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "mic"), for: .normal)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("", for: .normal )
        
    }
  
}
//new fixing for iphone x

extension JSQMessagesInputToolbar {
    override open func didMoveToWindow() {
        super.didMoveToWindow()
        guard  let window = window else { return }
        
        if #available(iOS 11.0, *) {
            let anchor = window.safeAreaLayoutGuide.bottomAnchor
            bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: anchor, multiplier: 1.0).isActive = true
        }
    }
}
//END fixing
