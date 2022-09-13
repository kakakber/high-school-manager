//
//  AppDelegate.swift
//  AppMascheroni
//
//  Created by Enrico Alberti on 30/09/17.
//  Copyright © 2017 Enrico Alberti. All rights reserved.
//

import UIKit
import Firebase
import DropDown
import GoogleSignIn
import JSSAlertView
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //v UITabBar.appearance().tintColor = .black
        DropDown.startListeningToKeyboard()
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }


    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //logIn con Google
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
        
        print("Successfully logged into Google", user)
        //accesso avvenuto con successo
        GDUID = user.userID
        GDnome = user.profile.name
        GDmail = user.profile.email
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                //errore
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
            
            guard let uid = user?.uid else { return }
            print("Successfully logged into Firebase with Google", uid)
            let userID = FIRAuth.auth()?.currentUser?.uid
            let ref = FIRDatabase.database().reference()
            
            let databaseRef = FIRDatabase.database().reference()
            
            databaseRef.child("studenti").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                
                if snapshot.hasChild(userID!){
                    
                }else{
                    
                    let data: Dictionary<String, Any> = ["mail": GDmail, "nome": GDnome, "classe" : "", "messaggi": "", "uid" : userID!];
                     ref.child("studenti").child(userID!).updateChildValues(data);
                }
                
                
            })
            
            //tutto è stato salvato nel database si può procedere con la creazione dell'account
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"nextView")
            let navController = UINavigationController.init(rootViewController: viewController)
            
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                currentController.present(navController, animated: false, completion: nil)
            }

        })
    }

    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
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
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}


