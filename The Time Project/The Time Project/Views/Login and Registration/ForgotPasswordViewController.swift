//
//  ForgotPasswordViewController.swift
//  Time_Project
//
//  Created by Nikola Laskov on 26.03.22.
//

import Foundation
import UIKit

class ForgotPasswordViewController: UIViewController{
    
    @IBOutlet var email: UITextField!
    @IBOutlet var sentEmailButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            titleLabel.text = "Забравена парола"
            email.placeholder = "Имейл"
            sentEmailButton.setTitle("Изпрати имейл", for: .normal)
        }
        else{
            titleLabel.text = "Forgoten password"
            email.placeholder = "Email"
            sentEmailButton.setTitle("Send emial", for: .normal)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @IBAction func sentEmailButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        
        AuthManager.shared.forgotPassword(email: email.text){ success, error in
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                self.errorSetter(error: error as! AuthError)
                self.errorLabel.isHidden = false
            }
        }
        
        
    }
    
    func errorSetter(error: AuthError){
        
        if DatabaseUserManager.shared.bg{
            if error == .defaultError {
               self.errorLabel.text = "Нещо не е наред."
               
           } else if error == .noEmail {
                self.errorLabel.text = "Трябва имейл"
                
            } else if error == .noUser {
                self.errorLabel.text = "Имейла или паролата са невалидни"
                
            } else if error == .invalidEmail {
                self.errorLabel.text = "Невалиден имейл"
            }
        }
        else{
            if error == .defaultError {
               self.errorLabel.text = "Something is wrong"
               
           } else if error == .noEmail {
                self.errorLabel.text = "Email is required"
                
            } else if error == .noUser {
                self.errorLabel.text = "Email or password incorect"
                
            } else if error == .invalidEmail {
                self.errorLabel.text = "Invalid email"
                
            } 
        }
        
        
    }
    
    
    
    
    
    
}
