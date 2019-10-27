//
//  ProfileViewTableViewController.swift
//  my first app
//
//  Created by Adam Essam on 8/16/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import UIKit

class ProfileViewTableViewController: UITableViewController {
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var messageButtonOutlet: UIButton!
    @IBOutlet weak var callButtonOutlet: UIButton!
    @IBOutlet weak var blockUserButtonOutlet: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var user:FUser? //el variable dah ely h3ml pass ll7agat bta3t ely user ely 3mlt press 3aleh 34an tban
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: IBAction
    
    @IBAction func callButtonPressed(_ sender: Any) {
        print("call with \(user!.fullname)")
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) { //esmha chat fel course
        
         print("chat with user \(user!.fullname)")
    }
    
    @IBAction func blockUserButtonPressed(_ sender: Any) {
        
        var currentBlockedIds = FUser.currentUser()!.blockedUsers
        
        if currentBlockedIds.contains(user!.objectId) {
            //remove el user men el block list
            let index = currentBlockedIds.firstIndex(of: user!.objectId)!
            currentBlockedIds.remove(at: index)
        } else { //hrg3 el user fel block list aw adef 7d gded
            currentBlockedIds.append(user!.objectId)
        }
        //hena h3ml update ll cahnges deh locally w 3l firebase b2a 34an tt save
        
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID : currentBlockedIds]) { (error) in
            if error != nil {
                print("error\(error!.localizedDescription)")
                return
            }
            self.updateBlockStatus()
        }
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    //to remove sections header ykon ben kol section w el tany fasel bdl el headers
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "" //rkz hena fel return type string feh wahda tanya return type [string] fah dah mynf34 empty string mmken nil lo 3ayz mrg34 7aga
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { //tb3n lazem kol el func yt3mlha override 34an fel tableView asln el funcs deh already exist
        return UIView()
    }

    //34an el goz ely hykon fo2 el section lma nshel el headers
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0 //b3ml check lo dah awel section mt3mlo4 height
        }
        return 30 //8er keda byrga3 30 fel height
    }
    
    
    //MARK: Setup UI
    
    func setupUI(){
        
        //b3ml check asln 3ndi user h3mlo setup fel view wala l2a
        if user != nil {
            self.title = "Profile"
            fullNameLabel.text = user!.fullname
            phoneNumberLabel.text = user!.phoneNumber
         //bt4of el user dah m3mlo block wala l2a
            updateBlockStatus()
            
            //34an ngeb el sora b2a
            //3ndna function gahza bt3ml keda
            imageFromData(pictureData: user!.avatar) { (avatarImage) in
                
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked //hena unrap 34an na et2kd asln fel if condition enha mesh bnil fa aked feh value httb3t
                    //a5er heta deh circleMasked 34an t5leha circle w shklha helwo
                }
            }
        }
    }
    
    //hena hn3ml function bt3ml update ll blockuser button lo na 3mlo block yzhrly unblock lo mesh 3mlo yzhrly block
    func updateBlockStatus() {
        // hena ba4of bas 3ala ana fate7 profile bta3y wala bta3 7ad tany fa eh ely hyzhrly
        if user!.objectId != FUser.currentId() {
            blockUserButtonOutlet.isHidden = false //hena 34an lo na ft7t el profile bta3y ml2e4 asln el button bta3 el block mesh 3ml block lnfsy na ya3ni
            messageButtonOutlet.isHidden = false
            callButtonOutlet.isHidden = false
        }
        else {
            blockUserButtonOutlet.isHidden = true
            messageButtonOutlet.isHidden = true
            callButtonOutlet.isHidden = true
            
        }
        
        //in FUSER file there is a var called blockeduser tb3n hnqaren hl el id bta3 el user dah fel block list wala l2a
    
        if FUser.currentUser()!.blockedUsers.contains(user!.objectId) {
            
            blockUserButtonOutlet.setTitle("Unblock User", for: .normal)
        } else {
            blockUserButtonOutlet.setTitle("Block User", for: .normal)
        }
    }
    
    
}
