//
//  addBookViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import UIKit

class addBookViewController:UIViewController{
    
    @IBOutlet var bookTitle: UITextField!
    @IBOutlet var bookPriority: UISegmentedControl!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        DatabaseBookManager.shared.addBook(name: bookTitle.text, priority: bookPriority.selectedSegmentIndex){ success,error in
            
            if success{
                _ = self.navigationController?.popViewController(animated: true)
                
            }
            else{
                self.errorLabel.text = "Title required"
                self.errorLabel.isHidden = false
            }
        }
    }
}
