//
//  UsersTableViewController.swift
//  my first app
//
//  Created by Adam Essam on 8/3/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

//hena 34an el search ysht8al lazem 22ol eno UsersTableViewController dah is a subClass men el UISearchResultUpdating zy mahowa subClass men el tableViewController
//tb3n hena kman lazem a3ml inhertancec men el tableviewCellDelegate 34an ast3mlo conform to the protocol
class UsersTableViewController: UITableViewController, UISearchResultsUpdating, UserTableViewCellDelegate {
    
    
   
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var filterSegmentedControll: UIView!
    //hena 3yzen shwet variables 34an n3ml save fehom ll user ely hngbha men el firebase Store
    
    var allUsers: [FUser] = []
    var filteredUsers: [FUser] = []
    //el stren dol 34an y2sm el users bel alphabets
    
    var allUsersGroupped = NSDictionary() as! [String : [FUser]]
    var sectionTitleList : [String] = []
    //3yzen n3ml search bar b2a 34an nsearch throw the users
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //el title ely m7tot 3ala el page ely feha el users
       self.title = "Users"
    //dah 34an m5lish klmet Users kbera zy Settings w Chats
        navigationItem.largeTitleDisplayMode = .never
    //hena 34an a4el el 5tot ely mlhash lazma ben el cells
        tableView.tableFooterView = UIView()
    //34an n7ot our search Bar
        navigationItem.searchController = searchController
    //hena m3naha el results ht5odha meny ana self men el view dah ely nta wa2ef 3aleh
        searchController.searchResultsUpdater = self
    //deh 34an lma access el bar bta3 el search el background tfdl zahra my3mlsh 3aleha blur keda aw tb2a mohmsha
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
       loadUsers(filter: kCITY)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
     // el section hena howa msln kol el contacts ely esmohom bybd2 b7r el A by7tohom kolo fe section wahed wa hakza
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        } else {
            return allUsersGroupped.count
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        } else {
            //find section title
            let sectionTitle = self.sectionTitleList[section]
            
            //user for given title
            let users = self.allUsersGroupped[sectionTitle]
            return users!.count
        }
        
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //hena bn3ml down cast 3ala el view ely na 3ayz aro7lo ely howa eh b2a el page ely feha el custom cell bta3tna
        // w dah custom table view cell mesh zy ely na 3mlo fel settings dah el default el 3ady
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell

        // Configure the cell...
        
        // now fe 7aga mohema 3ayz a3mlha mfrod a5li el user ytb3at dinamicly
        
        var user: FUser
        // w n3ml check hl el user dah by3ml search asln wala l2a
        if searchController.isActive && searchController.searchBar.text != "" {
          
            user = filteredUsers[indexPath.row]
            
        } else {
            // el Error ely kan f45ni hena b3ml access ll Row fa 34an keda byrg3 awel user mwgod fel row bas fa 34an keda mtkrren
            //ely el mfrod ykon eny mfrod a3ml access ll section mesh el Row fa bdl [indexPath.row -> indexPath.section]
           let sectionTitle = self.sectionTitleList[indexPath.section]
           
            let users = self.allUsersGroupped[sectionTitle]
            user = users![indexPath.row]
        }
        
     
        
        //b3ml generate ll cell 
        cell.generateCellWith(fUser: user, indexPath: indexPath)

        
        //b3d el generate bta3 el cell hn3ml setup ll Delegate
        cell.delegate = self
        return cell
    }
    
    
    //MARK: TableView Delegate
    
    //hena btrga3 el 7rof ely mwgoda fel headers
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            //in this case we check lo el user by3ml searching now yb2a mfe4 7aga tzhar
            return ""
        } else {
            return sectionTitleList[section]
        }
    }
    
    //hena brga3 el index ely btkon fel ganb
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive && searchController.searchBar.text != "" {
            //in this case we check lo el user by3ml searching now yb2a mfe4 7aga tzhar
            return nil
        } else {
            return self.sectionTitleList
        }
    }
    
    //hena hn3ml el heta ely howa lma ykon feh 7rof fel ganb keda wt press 3aleha b jump 3ala el section 3ala tol
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    // this function get called everytime we select our user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var user: FUser
        // w n3ml check hl el user dah by3ml search asln wala l2a
        if searchController.isActive && searchController.searchBar.text != "" {
            
            user = filteredUsers[indexPath.row]
            
        } else {
            // el Error ely kan f45ni hena b3ml access ll Row fa 34an keda byrg3 awel user mwgod fel row bas fa 34an keda mtkrren
            //ely el mfrod ykon eny mfrod a3ml access ll section mesh el Row fa bdl [indexPath.row -> indexPath.section]
            let sectionTitle = self.sectionTitleList[indexPath.section]
            
            let users = self.allUsersGroupped[sectionTitle]
            user = users![indexPath.row]
        }
        
        // we need to create Recent chat so we will work with our chat view
        // hnro7 3ala el FUser w hnCrete a swift file Esmo Recent
        
        startPrivateChat(user1: FUser.currentUser()!, user2: user) // hena pass currentUser w el tany el user ely 3ayz a chat m3ah 
        
        
    }
    
    //3yzen n3ml Load ll users b2a men el dataBase
    func loadUsers(filter: String) {
        //el filter hena 3ayd 3ala el city w el country w el 7aga ely mwgoda fel filterSegmentedControll
        ProgressHUD.show() // dah hy show the loading bar bas
        
        var query: Query!
        
        switch filter {
        //hena hn3ml access ll firebase b2a 3ntre2 refrence function
        case kCITY:
            //mmken t3ml check lo nset hya bt access eh asln men el fireStore command + click
            //na hena asln 3ayz el users ely el city bta3thom zy na h4of el city bta3ty eh el awel w b3den ageb ely zy
            query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
        case kCOUNTRY:
            query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()!.country).order(by: kFIRSTNAME, descending: false)
        default:
            //hrg3 All fa mesh m7tag a3ml filter Where hrg3 kolo + h3ml lly rage order
            query = reference(.User).order(by: kFIRSTNAME, descending: false)
        }
        
        //n3ml run ll query b2a
        query.getDocuments { (snapshot, error) in
            //lazem a3ml empty ll Array el awel 34an mesh kol mara y3ml load fa yro7 mzwed 3ala adem keda hykon feh 7agat kteer mtkrara
            
            self.allUsers = []
            self.sectionTitleList = []
            self.allUsersGroupped = [:] //34an dah dictionary
            
            if error != nil {
                print(error!.localizedDescription)
                ProgressHUD.dismiss() //34an el loading bar yro7
                self.tableView.reloadData()
                return
            }
            guard let snapshot = snapshot else {
                ProgressHUD.dismiss(); return
            }
            
            if !snapshot.isEmpty {
                
                for userDictionary in snapshot.documents {
                    
                    let userDictionary = userDictionary.data() as NSDictionary //hena ba2olo eno no3 el data NS Data'
                    // kol file mwgod b2a 3ala el fireStore 3yzen n3mlo FUser Object w a7oto fel Array
                    
                    let fUser = FUser(_dictionary: userDictionary)
                    //mfrod eny brga3 kol el user bma fehom ana kman fa ana mesh 3ayzny azhar 34an aked mesh h3ml chat m3 nafsy ya3ni
                    //FUser.currentId() btrg el id bta3 el user ely currently logged in now
                    //w hn3mlo compare m3 el user ely na lesa 3mlo ely howa fUser
                    if fUser.objectId != FUser.currentId() {
                        
                        self.allUsers.append(fUser)
                    }
                }
                
                //split to Groups
                self.splitDataIntoSection()
                self.tableView.reloadData()
                
            }
            
            self.tableView.reloadData()
            ProgressHUD.dismiss()
            
        }
    }
    
    
    //MARK: IBActions
    
    //hena kol mara el user hyswitch between el values ely fo2 el function deh httnada
    @IBAction func filterSegmentValueChanged(_ sender: UISegmentedControl) {
        
        //switch dah depend 3ala el selectedSegmentIndex el homa na 3mlhom 3 asln fa men 0..2
        switch sender.selectedSegmentIndex {
        case 0:
            loadUsers(filter: kCITY)
        case 1:
            loadUsers(filter: kCOUNTRY)
        case 2:
            loadUsers(filter: "")
        default:
            return
        }
    }
    
    
    
    
   
    //MARK: Search Controller Functions
    
    //34an el search ysht8al asln el mechanism bta3o
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredUsers = allUsers.filter({ (user) -> Bool in
            //we check if the firstname matches with our searchText
            //lazem n5li kolo lowercase 34an hya case Sensitive lo sbtha mesh hygeb 8er lma akteb el esm belzabt b7rofo swa2 capital aw small
            return user.firstname.lowercased().contains(searchText.lowercased())
        })
        //34an kol ma nSearch 3ala 7aga kol mara y3ml reload bel data el gdeda
        tableView.reloadData()
    }
    
    //hydrb error awel ma 22olo UISearchResultsUpdating nPress fix hy7otlna el function deh required
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    //MARK: Helper functions
    //fileprivate deh mesh h2dr ast5dmha fe ay file 8er dah
    fileprivate func splitDataIntoSection() {
        
        var sectionTitle: String = ""
        
        for i in 0..<self.allUsers.count {
            
            let currentUser = self.allUsers[i]
            
            let firstChar = currentUser.firstname.first! //first letter of the users name
            
            let firstCarString = "\(firstChar)" // n7wlo L String
            
            // dah 34an msln lo feh user esmo Adam w user tany esmo Ahmed my3mlsh 2 section with letter A maho keda keda feh section asln bade2 b A
            if firstCarString != sectionTitle {
                
                sectionTitle = firstCarString
                
                self.allUsersGroupped[sectionTitle] = []
                
                self.sectionTitleList.append(sectionTitle)
          
            }
            
            //n7ot el user fel dictionary b2a
            self.allUsersGroupped[firstCarString]?.append(currentUser)
            
        }
        
    }
  
    //MARK: UserTableViewCellDelegate
    
    func didTapAvatarImage(indexPath: IndexPath) {
       
        //34an ngeb el profileView la n3mlo instantiate
        
        let profileVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as! ProfileViewTableViewController
        
        //ngeb el user b2a 34an n3mlo present w n3rdo b2a lazem ykon nfs el code ely fo2 34an bardo dah depend 3ala eno fel search mode wala l2a
        var user: FUser
        // w n3ml check hl el user dah by3ml search asln wala l2a
        if searchController.isActive && searchController.searchBar.text != "" {
            
            user = filteredUsers[indexPath.row]
            
        } else {
            // el Error ely kan f45ni hena b3ml access ll Row fa 34an keda byrg3 awel user mwgod fel row bas fa 34an keda mtkrren
            //ely el mfrod ykon eny mfrod a3ml access ll section mesh el Row fa bdl [indexPath.row -> indexPath.section]
            let sectionTitle = self.sectionTitleList[indexPath.section]
            
            let users = self.allUsersGroupped[sectionTitle]
            user = users![indexPath.row]
        }
        
        profileVc.user = user
        
        //n3ml present
        self.navigationController?.pushViewController(profileVc, animated: true)
    }
    
}
