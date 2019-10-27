//
//  ChatsViewController.swift
//  my first app
//
//  Created by Adam Essam on 8/3/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import UIKit
import FirebaseFirestore

//ha conform RecentChatsTableViewCellDelegate 34an lma a press 3ala el avatar yft7li el profile msln
//mtnsa4 hydrb error 34an y3ml fix zwd el function na 3mlha t7t ely hya didTapAvatarImage
//3yzen n3ml conform ll search kman
class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecentChatsTableViewCellDelegate, UISearchResultsUpdating {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var recentChats: [NSDictionary] = []
    var filteredChats: [NSDictionary] = []
    
    //create listner 34an to listen to a new chats
    // w men domn el asbab en e7na 3mlna create ll listener ano lo na tl3t men chat ro7 ay page tanya e7na keda mesh m7tagen nfdl nlisten 3l chat fa dah hadr ll batterry w el network
    //34an keda howa hyfdl ylsn l7d ma el chats deh t2fl hy2f
    var recentListener : ListenerRegistration!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //hn3ml hena two functions 34an lo e7na tl3na men el view bta3 el chats dah keda el viewDidload mesh htnady 3ala function loadRecentChat() tany fa keda lo galy msgs mesh htsm3 l2no el listen m2fol
    
    override func viewWillAppear(_ animated: Bool) {
        loadRecentChat()
        //hena bnshel el cell ely fadya
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        recentListener.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        setTableViewHeader()
    }
    

    //MARK: IBActions
    
    @IBAction func createNewChatButtonPressed(_ sender: Any) {
        
        //mfrod access our storyBoard 34an ngeb tableView
        //tb3n  el Identifier bta3 men b2a bta3 el table View ely na 3ayz a5od meno ely howa feh el usersTableView
        //w b3ml downCast tb3n 34an 22olo eno dah zy el UsersTableViewController
        let userVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersTableView") as! UsersTableViewController
        self.navigationController?.pushViewController(userVc, animated: true)
    }
    
    //MARK: TableView DataSource
    
    //hint mfrod bn2ol feh kam section fel tableView dah bas lom2olnash el default bta3ha 1 section will be implemented
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("we have \(recentChats.count) recents")
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredChats.count
        } else {
        
            return recentChats.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentChatsTableViewCell
        
        //hena hnload our Recent Chats 34an n Displat them
        
        cell.delegate = self
        var recent: NSDictionary!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            recent = filteredChats[indexPath.row]
            
        } else {
            recent = recentChats[indexPath.row]
          
        }
        
        cell.generateCell(recentChat: recent, indexPath: indexPath)
        
        
        
        return cell
    }
    
    //MARK: TableViewDelegate functions
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //we need a recent temp dictionary to know which of the mwe will mute and which will be deleted
        
        var tempRecent: NSDictionary!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            tempRecent = filteredChats[indexPath.row]
            
        } else {
            tempRecent = recentChats[indexPath.row]
            
        }
        
        var muteTitle = "Unmute"
        var mute = false
        
        //memebertoPush are the members who will recieve the push notifications
        //hena b3ml check hl el membersToPush el current user mwgod fehom wala l2a yb2a keda dah mesh m3mlo mute
        if (tempRecent[kMEMBERSTOPUSH] as! [String]).contains(FUser.currentId()) {
            
            muteTitle = "Mute"
            mute = true
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            //el code hena hy7sal lma a Press 3ala el delete Button
          //awel 7aga m7tagha eny ashel el el caht dah men el local variable el howa hena el recentChats
            
            self.recentChats.remove(at: indexPath.row)
            deleteRecentChat(recentChatDictionary: tempRecent)
            
            self.tableView.reloadData()
        }
        
        let muteAction = UITableViewRowAction(style: .default, title: muteTitle) { (action, indexPath) in
            
            print("Muted\(indexPath)")
        }
        
        muteAction.backgroundColor = #colorLiteral(red: 0.097798918, green: 0.4699948699, blue: 1, alpha: 1)
        
        return [deleteAction, muteAction]
    }
    
    //n3ml function lma n5tar el cell mo3yna 34an n3ml chat
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //bardo lazem n4of e7na fel search mode wala l2a 34an n3raf emta hn select
        var recent: NSDictionary!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            recent = filteredChats[indexPath.row]
            
        } else {
            recent = recentChats[indexPath.row]
            
        }
        
        //restart chat 34an lo 7ad men el users msa7 w b3den hd men el msa7hom b3tlo tany
        //to show chat View
        restartRecentChat(recent: recent)
        
        //hena lma a press 3ala ay user mfrod y3ml presenet ll chat view Controller ely na 3mlo fel secondary views
        let chatVC = ChatViewController()
        //hena abl ma n3ml push ll view bt3na fel stack 34an yt3raf hnshel bottomBar
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
    //MARK: LoadRecentChats
    
    func loadRecentChat() {
        
        //access our Firestore
        
        recentListener = reference(.Recent).whereField(kUSERID, isEqualTo: FUser.currentId()).addSnapshotListener({ (snapshot, error) in
            
            guard let snapshot = snapshot else  {return}
            
            self.recentChats = []
            
            if !snapshot.isEmpty {
                
                //hena 3mlna awel casting 34an n5leh array w nnady el function bta3t el sort ely fel array with key el howa el date hnrteb 3ala asasso tb3n na na 3ayz agdad tare5 ykon howa on top fa lo ascending yb2a false lo descending yb2a true
                let sorted = ((dictionaryFromSnapshots(snapshots: snapshot.documents)) as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)]) as! [NSDictionary]
            //the second down casting 34an h3ml loop 3ala el sorted deh w el sorted mfrod trga3 [NSDictionary] leh 34an tkon m3 el recent chats
                
                for recent in sorted {
                    
                    // lo mfe4 last message between me and the user im chating with yb2a mesh lazem yzhar 7aga fel Recent l2no mfe4 w b3ml el checks el b2aya 3ala RoomID w el RecentID 34an mykon4 corrupt file
                    if recent[kLASTMESSAGE] as! String != "" && recent[kCHATROOMID] != nil && recent[kRECENTID] != nil {
                        
                        self.recentChats.append(recent)
                    }
                }
            
            self.tableView.reloadData()
                
            }
   
            
        })
        
    }
    
    //MARK: custom tableViewHeader
    
    func setTableViewHeader() {
        
        //hena dah view fo2 el chats
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
        //hean dah view fo2 el view 34an yt7t feh el button bta3 New Group Create
        let buttonView = UIView(frame: CGRect(x: 0, y: 5, width: tableView.frame.width, height: 35))
        //el view kolo bykon 220 f7na shela 110 keda el button hybd2 men 110.7aga l7d el a5er w b3den 2olna width = 100 keda hytfdl 10 men el right as a margin
        let groupButton = UIButton(frame: CGRect(x: tableView.frame.width - 110, y: 10, width: 100, height: 20))
        //el function bta3t el button b2a
        groupButton.addTarget(self, action: #selector(self.groupButtonPressed), for: .touchUpInside)
        
        //set title
        groupButton.setTitle("New Group", for: .normal)
        //color literal hya ely btgeb el box bta3 el color dah
        let buttonColor = #colorLiteral(red: 0.097798918, green: 0.4699948699, blue: 1, alpha: 1)
        groupButton.setTitleColor(buttonColor, for: .normal)
        
        //n3ml line b2a y3ml sperate ben el button w el chats
        // el y htkon el tableview height kolo -1 y3ni hybd2 men el -1 deh
        let lineView = UIView(frame: CGRect(x: 0, y: headerView.frame.height - 1 , width: tableView.frame.width, height: 1))
        
        lineView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        
        buttonView.addSubview(groupButton)
        headerView.addSubview(buttonView)
        headerView.addSubview(lineView)
        
        tableView.tableHeaderView = headerView
        
    }
    
    @objc func groupButtonPressed() {
        print("hello")
    }
    
    
    //MARK: RecentChatsCell Delegate
    
    func didTapAvatarImage(indexPath: IndexPath) {
        
     
        
        var recentChat: NSDictionary!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            recentChat = filteredChats[indexPath.row]
            
        } else {
            recentChat = recentChats[indexPath.row]
            
        }
        
        if recentChat[kTYPE] as! String == kPRIVATE {
            
            reference(.User).document(recentChat[kWITHUSERUSERID] as! String).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                if snapshot.exists {
                    let userDictionary = snapshot.data() as! NSDictionary
                    
                    let tempUser = FUser(_dictionary: userDictionary)
                    
                    self.showUserProfile(user: tempUser)
                }
            }
        }
    
    }
    
    func showUserProfile(user: FUser) {
        
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as! ProfileViewTableViewController
        
        profileVC.user = user
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    //MARK: Search Controller Functions
    
    //34an el search ysht8al asln el mechanism bta3o
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredChats = recentChats.filter({ (recentChat) -> Bool in
            //we check if the firstname matches with our searchText
            //lazem n5li kolo lowercase 34an hya case Sensitive lo sbtha mesh hygeb 8er lma akteb el esm belzabt b7rofo swa2 capital aw small
            print(recentChat)
            return (recentChat[kWITHUSERUSERNAME] as! String).lowercased().contains(searchText.lowercased())
        })
        //34an kol ma nSearch 3ala 7aga kol mara y3ml reload bel data el gdeda
        tableView.reloadData()
    }
    
    //hydrb error awel ma 22olo UISearchResultsUpdating nPress fix hy7otlna el function deh required
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}
