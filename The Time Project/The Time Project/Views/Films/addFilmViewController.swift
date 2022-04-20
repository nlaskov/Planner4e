//
//  addFilmViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import UIKit

class addFilmViewController:UIViewController{
    
    @IBOutlet var filmTitle: UITextField!
    @IBOutlet var filmPriority: UISegmentedControl!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        DatabaseFilmManager.shared.addFilm(name: filmTitle.text, priority: filmPriority.selectedSegmentIndex){ success,error in
            
            if success{
                _ = self.navigationController?.popViewController(animated: true)
                
            }
            else{
                self.errorLabel.text = "Film required"
                self.errorLabel.isHidden = false
            }
        }
    }
}


