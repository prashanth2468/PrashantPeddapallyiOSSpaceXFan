//
//  CustomTabbarController.swift
//  iOSSpaceXFan
//
//  Created by Rama's_iMac on 14/08/21.
//

import Foundation
import UIKit

var tabbarSelectedIndex = 0
var notifyCount = 0

class CustomTabbarController: UITabBarController, UITabBarControllerDelegate {
    var window: UIWindow?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBarController?.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
    }
  
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if  tabBarController.selectedIndex == 0{
            print("First tab")
        }else if tabBarController.selectedIndex == 1{
            let appDe = (UIApplication.shared.delegate) as! AppDelegate
            appDe.CheckFaceIdTouchId()
            print("second tab")
        }else if tabBarController.selectedIndex == 1{
            print("third tab")
        }
        
    }
    
}



    
   


