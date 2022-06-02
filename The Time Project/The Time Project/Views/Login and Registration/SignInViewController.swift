//
//  SignInViewController.swift
//  Time_Project
//
//  Created by Nikola Laskov on 26.03.22.
//

import Foundation
import UIKit
import FirebaseAuth

class SignInViewController: UIViewController{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var forgotenPassword: UIButton!
    
    override func viewDidLoad(){
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
            titleLabel.text = "Вход"
            email.placeholder = "Имейл"
            password.placeholder = "Парола"
            signInButton.setTitle("Вход", for: .normal)
            forgotenPassword.setTitle("Забравена парола?", for: .normal)
        }
        else{
            titleLabel.text = "Sign In"
            email.placeholder = "Email"
            password.placeholder = "Password"
            signInButton.setTitle("Sign In", for: .normal)
            forgotenPassword.setTitle("Forgoten password?", for: .normal)
        }
    }
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        //Hide error button
        self.errorLabel.isHidden = true
        
        AuthManager.shared.login(email: email.text, password: password.text){ success, error in
            if success {
                let uid = Auth.auth().currentUser!.uid
                let _ = DatabaseUserManager.shared.getUser(UID: uid){
                    self.setLanguage()
                }
                self.dismiss(animated: true, completion: nil)
            }
            else {
                //If registration isn`t successful show Error lable
                self.errorSetter(error: error as! AuthError)
                self.errorLabel.isHidden = false
            }
        }
        
        
        
    }
    
    func errorSetter(error: AuthError){
        if DatabaseUserManager.shared.bg{
            if error == .defaultError {
               self.errorLabel.text = "Нещо не е наред"
               
           } else if error == .noEmail {
                self.errorLabel.text = "Трябва имейл"
                
            } else if error == .noPassword {
                self.errorLabel.text = "Трябва парола"
                
            } else if error == .noUser {
                self.errorLabel.text = "Имейла или паролата са грешни"
                
            } else if error == .invalidEmail {
                self.errorLabel.text = "Грешен имейл"
            }
        }
        else{
            if error == .defaultError {
               self.errorLabel.text = "Something is wrong"
               
           } else if error == .noEmail {
                self.errorLabel.text = "Email is required"
                
            } else if error == .noPassword {
                self.errorLabel.text = "Password is required"
                
            } else if error == .noUser {
                self.errorLabel.text = "Email or password incorect"
                
            } else if error == .invalidEmail {
                self.errorLabel.text = "Invalid email"
                
            }
        }
    }
    
    
    
}
