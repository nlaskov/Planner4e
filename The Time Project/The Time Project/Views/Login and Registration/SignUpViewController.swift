//
//  SignUpViewController.swift
//  Time_Project
//
//  Created by Nikola Laskov on 26.03.22.
//

import Foundation
import UIKit
import FirebaseAuth


class SignUpViewController: UIViewController{
    
   
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var fullName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var SignInLabel: UILabel!
    @IBOutlet var SignInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            titleLabel.text = "Регистрация"
            fullName.placeholder = "Пълно име"
            email.placeholder = "Имейл"
            password.placeholder = "Парола"
            signUpButton.setTitle("Създай своя акаунт", for: .normal)
            SignInLabel.text = "Вече имаш акаунт?"
            SignInButton.setTitle("Влез тук!", for: .normal)
        }
        else{
            titleLabel.text = "Sign Up"
            fullName.placeholder = "Full name"
            email.placeholder = "Email"
            password.placeholder = "Password"
            signUpButton.setTitle("Create your account", for: .normal)
            SignInLabel.text = "Already have an acount?"
            SignInButton.setTitle("Sign In!", for: .normal)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        //Hide error button
        self.errorLabel.isHidden = true
        
        //Start loading animation
        
        AuthManager.shared.singUp(email: email.text, password: password.text, fullname: fullName.text) { success, error in
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
            
            //Stop animation
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
                
            } else if error == .invalidEmail {
                self.errorLabel.text = "Невалиден имейл"
                
            } else if error == .emailAlreadyInUse {
                self.errorLabel.text = "Този имейл вече се използва"
                
            } else if error == .weakPassword {
                self.errorLabel.text = "Паролата трябва да е поне 6 символа"
            }
        }
        else{
            if error == .defaultError {
               self.errorLabel.text = "Something is wrong"
               
           } else if error == .noEmail {
                self.errorLabel.text = "Email is required"
                
            } else if error == .noPassword {
                self.errorLabel.text = "Password is required"
                
            } else if error == .invalidEmail {
                self.errorLabel.text = "Invalid email"
                
            } else if error == .emailAlreadyInUse {
                self.errorLabel.text = "The email is already used"
                
            } else if error == .weakPassword {
                self.errorLabel.text = "Password should be at least 6 characters"
                
            }
        }
    }
    
    
}
