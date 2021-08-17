//
//  AppDelegate.swift
//  iOSSpaceXFan
//
//  Created by Rama's_iMac on 14/08/21.
//

import UIKit
import LocalAuthentication
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

 
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SpaceXCoreData")
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



//MARK:- Biometric auth / faceid auth
extension AppDelegate {
    
    func CheckFaceIdTouchId() {
        let version = OperatingSystemVersion(majorVersion: 13, minorVersion: 0, patchVersion: 0)
        if ProcessInfo.processInfo.isOperatingSystemAtLeast(version) {
            tappedFaceId()
        } else {
            tappedTouchId()
        }
    }
    
    func tappedTouchId(){
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Verify your TouchID!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        // Success case
                        
                        let beforeLoginStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let centerVC = beforeLoginStoryBoard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabbarController
                        let navigationVC = UINavigationController.init(rootViewController: centerVC)
                        self?.window?.rootViewController = navigationVC
                        
                        //                           let ac = UIAlertController(title: "You're a device Owner", message: "Welcome!", preferredStyle: .alert)
                        //                           ac.addAction(UIAlertAction(title: "OK", style: .default))
                        // self?.present(ac, animated: true)
                        
                    } else {
                        // error case
                        
                        let ac = UIAlertController(title: "Authentication failed", message: "Error Occured!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self?.window?.rootViewController?.present(ac, animated: true, completion: nil)
                        
                        //  self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry where touchId is not available
            
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.window?.rootViewController?.present(ac, animated: true, completion: nil)
            
            // present(ac, animated: true)
        }
        
    }
    
    func tappedFaceId(){
        guard #available(iOS 13.0, *) else {
            fatalError()
        }
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Verify your FaceID!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        // Success case
                        
                        let beforeLoginStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let centerVC = beforeLoginStoryBoard.instantiateViewController(withIdentifier: "CustomTabbarController") as! CustomTabbarController
                        let navigationVC = UINavigationController.init(rootViewController: centerVC)
                        
                        self?.window?.rootViewController = navigationVC
                        
                        
                        // let ac = UIAlertController(title: "You're a device Owner", message: "Welcome!", preferredStyle: .alert)
                        //  ac.addAction(UIAlertAction(title: "OK", style: .default))
                        // self?.present(ac, animated: true)
                        
                    } else {
                        // error case
                        
                        let ac = UIAlertController(title: "Authentication failed", message: "Error Occured!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        self?.window?.rootViewController?.present(ac, animated: true, completion: nil)
                        
                        //  self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry where faceId is not available
            
            
            let ac = UIAlertController(title: "Face ID not available", message: "Your device is not configured for Face ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            print("Your device is not configured for Face ID.")
            self.window?.rootViewController?.present(ac, animated: true, completion: nil)
            
            // present(ac, animated: true)
        }
        
    }
    
    
}

