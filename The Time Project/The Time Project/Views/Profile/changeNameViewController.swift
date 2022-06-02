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
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        DatabaseUserManager.shared.changeName(newName: newNameField.text)
        
        self.alertSuccess(sender)
    }
    
    func alertSuccess(_ sender: UIButton) {
        
        var title = ""
        var message = ""
        
        if DatabaseUserManager.shared.bg{
            title = "Сменено име"
            message = "Успешно смени името си!"
        }
        else{
            title = "Name changed"
            message = "You successfully changed your name!"
        }
        
        let alert = UIAlertController(title:title , message:message, preferredStyle: .alert)
        
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
    
    func setLanguage(){
        
        if DatabaseUserManager.shared.bg{
            newNameField.placeholder = "Ново име"
        }
        else{
            newNameField.placeholder = "New name"
        }
        
    }
}
