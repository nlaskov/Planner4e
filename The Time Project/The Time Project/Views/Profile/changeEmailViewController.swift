//
//  changeEmailViewControll.swift
//  The Time Project
//
//  Created by Nikola Laskov on 20.04.22.
//

import Foundation
import UIKit

class changeEmailViewController: UIViewController{

    @IBOutlet var newEmailField: UITextField!
    @IBOutlet var passwordField: UITextField!
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
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @IBAction func done(_ sender: UIButton) {
        self.errorLabel.isHidden = true
        
        AuthManager.shared.changeEmail(newEmail: newEmailField.text, password: passwordField.text) { success, error in
            if success {
                
                DatabaseUserManager.shared.changeEmail(newEmail: self.newEmailField.text)
                
                self.newEmailField.text = ""
                self.passwordField.text = ""
                self.alertSuccess(sender)
            }
            else {
                self.errorLabel.isHidden = false
                self.errorSetter(error: error as! AuthError)
            }
        }
    }
    
    func alertSuccess(_ sender: UIButton) {
        
        var title = ""
        var message = ""
        
        if DatabaseUserManager.shared.bg{
            title = "Сменен имейл"
            message = "Успешно смени имейла си!"
        }
        else{
            title = "Email changed"
            message = "You successfully changed your email!"
        }
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    func errorSetter(error: AuthError){
        
        if DatabaseUserManager.shared.bg{
            if error == .defaultError {
               self.errorLabel.text = "Нещо не е наред"
               
           } else if error == .noEmail {
                self.errorLabel.text = "Трябва имейл"
                
            } else if error == .noPassword {
                self.errorLabel.text = "Трябва парола"
                
            } else if error == .incorrectPassword {
                self.errorLabel.text = "Грешна парола"
                
            } else if error == .invalidEmail {
                self.errorLabel.text = "Грешен имейл"
                
            } else if error == .emailAlreadyInUse {
                self.errorLabel.text = "Този имейл вече се използва"
            }
        }
        else{
            if error == .defaultError {
               self.errorLabel.text = "Something isn`t right"
               
           } else if error == .noEmail {
                self.errorLabel.text = "Email required"
                
            } else if error == .noPassword {
                self.errorLabel.text = "Password required"
                
            } else if error == .incorrectPassword {
                self.errorLabel.text = "Wronge password"
                
            } else if error == .invalidEmail {
                self.errorLabel.text = "Wrong email"
                
            } else if error == .emailAlreadyInUse {
                self.errorLabel.text = "This email is already used"
            }
        }
        
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            newEmailField.placeholder = "Нов имейл"
            passwordField.placeholder = "Парола"
        }
        else{
            newEmailField.placeholder = "New Email"
            passwordField.placeholder = "Password"
        }
    }
}
