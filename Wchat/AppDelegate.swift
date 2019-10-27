//
//  AppDelegate.swift
//  my first app
//
//  Created by Adam Essam on 7/26/19.
//  Copyright © 2019 Adam Essam. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//hncreate el var dah 34an el auto login
    var authlistener: AuthStateDidChangeListenerHandle?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       FirebaseApp.configure()
    
        //AutoLogin
        authlistener = Auth.auth().addStateDidChangeListener({ (auth, user) in
            //hn remove el listner 34an mesh kol shwaya ylistner hya awel mara bas
            //ya3ni awel listen ygelo 5las mesh m7tag ylisten tany
            Auth.auth().removeStateDidChangeListener(self.authlistener!)
            
            if user != nil {
                
                if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
                   // 3yzen n3ml deh in the main thread 34an asln el func kolha bta3t el userdefault deh sh8ala fel background thread
                    DispatchQueue.main.async {
                        self.goToApp()
                    }
                }
            }
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK : GoToApp
    func goToApp() {
        //hena hnpost a notification that our user is logged in
        //FUser.currentId bt3ml pass ll id bta3 el user ely logged in
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID : FUser.currentId()])
        
        //heta deh 34an lo el user asln logged in yd5ol 3ala tol 3ala el tabBar controller lazem a7otha hena fel appDelegate 34an howa hytcheck while el application is gonna run
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        //our delegate is not a viewController so it cannot access present mainView
        //self.present(mainView, animated: true, completion: nil)
        
        self.window?.rootViewController = mainView
    }

}

