//
//  changeImageViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 26.05.22.
//

import Foundation
import UIKit
import Kingfisher

class changeImageViewController:UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var uploadButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    var imageName:String = DatabaseUserManager.shared.user.image
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StorageManager.shared.getProfilePicture(imageName: DatabaseUserManager.shared.user.image){urlString in
            
            let url = URL(string: urlString)
            self.profileImage.kf.setImage(with: url)
        }
    }
    
    @IBAction func pressSaveButton(_ sender: UIButton) {
        //Delete old image
        StorageManager.shared.deleteProfileImage(imageName: DatabaseUserManager.shared.user.image){
            StorageManager.shared.setProfileImage(imageName: self.imageName, image: self.profileImage.image!){
                DatabaseUserManager.shared.changeImage(newImageName: self.imageName)
                self.alertSuccess(sender)
            }
        }
    }
    
    func alertSuccess(_ sender: UIButton) {
        
        let title = "Profile image changed"
        let message = "You have successfully changed your profile image!"
        
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in _ = self.navigationController?.popViewController(animated: true)}))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    @IBAction func pressUploadButton(_ sender: Any) {
        let vc = UIImagePickerController();
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            imageName = imageURL.lastPathComponent
        }
        
        //Get selected image
        if let image = info[UIImagePickerController.InfoKey(rawValue:"UIImagePickerControllerEditedImage")] as? UIImage{
            profileImage.image = image
        }
        dismiss(animated: true);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
   
}
