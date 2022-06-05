//
//  profileMenuViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 20.04.22.
//

import Foundation
import UIKit
import Kingfisher

class profileMenuViewController:UIViewController{
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    
    @IBOutlet var changeNameButton: UIButton!
    @IBOutlet var changeEmailButton: UIButton!
    @IBOutlet var changePasswordButton: UIButton!
    @IBOutlet var changeImageButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUser()
        setLanguage()
    }
    
    func setUser(){
        
        if DatabaseUserManager.shared.user.image != "Image "{
            //getImage
            StorageManager.shared.getProfilePicture(imageName:DatabaseUserManager.shared.user.image){urlString in
                let url = URL(string: urlString)
                self.profileImage.kf.setImage(with:url)
            }
        }
        else {
            self.profileImage.image = UIImage(named: "person.fill")
        }
    }
    
    @IBAction func loguot(_ sender: Any) {
        
        var title = ""
        var message = ""
        var answear = ["",""]
        
        if DatabaseUserManager.shared.bg{
            title = "Излизане"
            message = "Сигурен ли си че искаш да излезнеш?"
            answear[0] = "Не"
            answear[1] = "Да"
        }
        else{
            title = "Log Out"
            message = "Are you sure you want to log out?"
            answear[0] = "No"
            answear[1] = "Yes"
        }
        
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: answear[0], style: .cancel))
        alert.addAction(UIAlertAction(title: answear[1], style: .destructive, handler: { _ in
            AuthManager.shared.logout { success in
                if (success) {
                    DatabaseUserManager.shared.user = User()
                    DatabaseTaskManager.shared.tasks = []
                    DatabaseBookManager.shared.books_read = []
                    DatabaseBookManager.shared.books_unread = []
                    DatabaseFilmManager.shared.films_watched = []
                    DatabaseFilmManager.shared.films_unwatched = []
                    DatabaseResolutionManager.shared.resolutions_done = []
                    DatabaseResolutionManager.shared.resolutions_undone = []
                    DatabaseRecipesManager.shared.recipes = []
                    self.goToLogoutScene()
                   
                }
            }
        }))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = (sender as AnyObject).bounds
        }
        
        present(alert, animated: true)
    }
    private func goToLogoutScene() {
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginMenu") as! UINavigationController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true)
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changeLang(_ sender: Any) {
        DatabaseUserManager.shared.bg = !DatabaseUserManager.shared.bg
        DatabaseUserManager.shared.changeLanguage(newLanguage: DatabaseUserManager.shared.bg)
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            nameLabel.text = "Име: " + DatabaseUserManager.shared.user.name
            emailLabel.text = "Имейл: " + DatabaseUserManager.shared.user.email
            
            changeNameButton.setTitle("Промени името си", for: .normal)
            changeEmailButton.setTitle("Промени имейла си", for: .normal)
            changePasswordButton.setTitle("Промени паролата си", for: .normal)
            changeImageButton.setTitle("Промени снимката си", for: .normal)
            logoutButton.setTitle("Изход", for: .normal)
            
        }
        else{
            nameLabel.text = "Name: " + DatabaseUserManager.shared.user.name
            emailLabel.text = "Email: " + DatabaseUserManager.shared.user.email
            
            changeNameButton.setTitle("Change your name", for: .normal)
            changeEmailButton.setTitle("Change your email", for: .normal)
            changePasswordButton.setTitle("Change your password", for: .normal)
            changeImageButton.setTitle("Change your image", for: .normal)
            logoutButton.setTitle("Logout", for: .normal)
        }
        
        
    }
    
}
