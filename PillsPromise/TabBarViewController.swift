//
//  TabBarViewController.swift
//  PillsPromise
//
//  Created by guest on 2019/11/27.
//  Copyright © 2019 guest. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBar.items![0].title = "ALARM"
        //self.tabBar.items![1].title = "MY PILLS"
        //self.tabBar.items![2].title = "EXPIRATION"
        
        self.selectedIndex = 1
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
