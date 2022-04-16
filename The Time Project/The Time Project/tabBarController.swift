//
//  tabBarController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 16.04.22.
//

import Foundation
import UIKit
class tabBarController:UIViewController{
    @IBOutlet var profileButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileButton.title = "Profile"
    }
    
}
