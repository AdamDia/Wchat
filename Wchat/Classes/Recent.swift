//
//  Recent.swift
//  my first app
//
//  Created by Adam Essam on 8/20/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import Foundation

func startPrivateChat(user1 : FUser , user2 : FUser) -> String {
    
    //hna 3ayz a3ml Id ll current user w el user ely e5taro 34an y3ml m3ah chat fa lazem a3ml check el awel 3l IDS deh
    //34an mesh kol ma ad8at 3ala el user dah a3ml create ll chat space tanya l2a yrg3ni ll chat space ely kanet m3molha create fel awel
    
    let userId1 = user1.objectId
    let userId2 = user2.objectId
    
    var chatRoomId = ""
    
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        chatRoomId = userId1 + userId2
    } else {
        chatRoomId = userId2 + userId1
    }
    
    
    let memebers = [userId1, userId2]
    
    
    // create recent chat
    createRecent(memebers: memebers, chatRoomId: chatRoomId, withUserUserName: "", type: kPRIVATE, users: [user1, user2], avatarOfGroup: nil)
    
    
    return chatRoomId
    
}


//hena 3ml create llchat nfso tb3n el chat dah 2 types mmken ykon Due chat aw group chat
func createRecent(memebers : [String], chatRoomId: String, withUserUserName: String, type: String, users: [FUser]?, avatarOfGroup: String?) {
    // members ely fo2 deh read only can't be updated fa 3mlt tempMembers 34an at3amel m3aha
    var tempMembers = memebers
    //hena bt4of el chatRoomID dah 3ndi abl keda wala l2a
    reference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {return}
        
        if !snapshot.isEmpty {
            
            
            for recent in snapshot.documents {
                
                let currentRecent = recent.data() as NSDictionary
                
                if let currentUserId = currentRecent[kUSERID] {
                    //hena by3ml check lo el user 3ndo Recent Object mesh hy3mlo object tany maho already 3ndo fa bro7 gy shelo men el tempmembers el goz2 ely t7t b2a ely fadel men el tempmembers
                    if tempMembers.contains(currentUserId as! String) {
                        tempMembers.remove(at: tempMembers.firstIndex(of: currentUserId as! String)!) //hena 5letha firstIndex bdl index
                    }
                }
            }
        }
            //command + k lo 3ayz a3raf el curly prases bta3t ay 7aga bt5las fen
        //create Recent for Remaining users
        //hena el goz2 b2a el fadel fel tempmemebers dah ely m3ndo3 Recent object fa dah mafrod a3mlo create ll Object Recent
        for userId in tempMembers {
            //Create recent Items
            //pass ely 7agat ely etb3tet fo2 keda keda hya hya l2no el case deh mesh hyd5ol feha ela lma el tempmembers ytfdal feha users
            createRecentItem(userId: userId, chatRoomId: chatRoomId, members: memebers, withUserUserName: withUserUserName, type: type, users: users, avatarOfGroup: avatarOfGroup)
            
            
            
        }
        
        
        
        
    }
    
    
}



func createRecentItem(userId: String, chatRoomId: String, members: [String], withUserUserName: String, type: String, users: [FUser]?, avatarOfGroup: String?) {
    
    let localReference = reference(.Recent).document() // hena b3ml create ll document fadya 3ala firebase 34an a3ml 3aleha save
    let recentId = localReference.documentID
    let date = dateFormatter().string(from: Date()) // bn7awel el date l String
    
    var recent: [String : Any]!
    
    if type == kPRIVATE {
        // private
        
        var withUser: FUser?
        
        if users != nil && users!.count > 0 {
            
            if userId == FUser.currentId() {
                // create object for current user
                
                withUser = users!.last!
            } else {
                
                withUser = users!.first! //fe 7alet el private chat tb3n ana m3nde4 8er 2 users fa .first dah el current user w .last dah the other user
            }
        }
        
        // create el recent b2a
        recent = [kRECENTID : recentId , kUSERID : userId, kCHATROOMID : chatRoomId, kMEMBERS : members , kMEMBERSTOPUSH : members ,
            kWITHUSERUSERNAME : withUser!.fullname, kWITHUSERUSERID : withUser!.objectId, kLASTMESSAGE : "", kCOUNTER : 0, kDATE : date, kTYPE : type, kAVATAR : withUser!.avatar] as [String : Any]
        
    } else {
        
        //group chat
        
        if avatarOfGroup != nil {
            
            recent = [kRECENTID : recentId, kUSERID : userId, kCHATROOMID : chatRoomId, kMEMBERS : members, kMEMBERSTOPUSH : members, kWITHUSERUSERNAME : withUserUserName, kLASTMESSAGE : "", kCOUNTER : 0, kDATE : date, kTYPE : type, kAVATAR : avatarOfGroup!] as [String : Any]
        }
    }
    
    
    // save Recent chat
    localReference.setData(recent) // save in the firebase
    
}

    //Restart Chat
func restartRecentChat(recent: NSDictionary) {
    
    if recent[kTYPE] as! String == kPRIVATE {
        // note mohem hena lo na 3amel pass L kmembers fa keda lo na feh chat 3mlo mute keda hy3mlo recent w hy3mly ez3ag laken na hena h3ml pass ll memeberstopush
        createRecent(memebers: recent[kMEMBERSTOPUSH] as! [String], chatRoomId: recent[kCHATROOMID] as! String, withUserUserName: recent[kWITHUSERUSERNAME] as! String, type: kPRIVATE, users: [FUser.currentUser()!], avatarOfGroup: nil)
    }
    
    if recent[kTYPE] as! String == kGROUP {
        
        createRecent(memebers: recent[kMEMBERSTOPUSH] as! [String], chatRoomId: recent[kCHATROOMID] as! String, withUserUserName: recent[kWITHUSERUSERNAME] as! String, type: kGROUP, users: nil, avatarOfGroup: recent[kAVATAR] as? String)
        
    }
}

    //Delete recent chat

func deleteRecentChat(recentChatDictionary: NSDictionary) {
    
    //get the recentID
    
    if let recentId = recentChatDictionary[kRECENTID] {
        //bdwr 3ala el id bta3 el recent chat lo mwgod h3mlo delete w a3ml save bas keda
        
        reference(.Recent).document(recentId as! String).delete()
    }
}
