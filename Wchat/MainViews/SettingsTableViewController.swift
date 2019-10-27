//
//  SettingsTableViewController.swift
//  my first app
//
//  Created by Adam Essam on 8/2/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    

    //MARK: IBActions
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        FUser.logOutCurrentUser { (success) in
            if success {
                //show login view
                self.showLoginView()
            }
        }
    }
    
    func showLoginView() {
        
        //name: Main t3od 3ala el Main.storyboard w el identifier howa el storyboard ID
        // w mesh hn3ml down casting 34an dah viewController and bydaufalt a viewController
        //belzabt dah hytl3na men el page b logout w hyro7 wa5dna 3ala el welcome view ely howa bn3ml meno logIn
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
        
        self.present(mainView, animated: true, completion: nil)
    }
    
    
}
