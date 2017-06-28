//
//  ReminderTabViewController.swift
//  iMindYou
//
//  Created by Rajagopal on 6/28/17.
//  Copyright © 2017 Rajagopal. All rights reserved.
//

import UIKit
import os.log


class ReminderTabbedViewController: UITabBarController, UITabBarControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        var tabView = AppTabView.Current
        switch(tabBarIndex) {
        case 0:
            tabView = AppTabView.Current
            break
        case 1:
            tabView = AppTabView.Past
            break
        default:
            os_log("Unkown Tab selected, not handling datafetch", log: .default, type: .error)
            
        }
        let homeViewController : UINavigationController? = self.viewControllers?[tabBarIndex]  as? UINavigationController
        
        let reminderViewController : ReminderTableViewController?  = homeViewController?.viewControllers[0] as? ReminderTableViewController
        reminderViewController?.tabViewSelected = tabView
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
