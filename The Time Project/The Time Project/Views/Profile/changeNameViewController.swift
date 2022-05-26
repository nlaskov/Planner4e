//
//  changeNameViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
import UIKit

class changeNameViewController:UIViewController{
    
    
    @IBOutlet var newNameField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        DatabaseUserManager.shared.changeName(newName: newNameField.text)
        
        self.alertSuccess(sender)
    }
    
    func alertSuccess(_ sender: UIButton) {
        let alert = UIAlertController(title: "Changed Name", message:"You have successfully changed your name!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
}
