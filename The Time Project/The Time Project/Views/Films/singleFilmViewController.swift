//
//  singleFilmViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
import UIKit

class singleFilmViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var edit = false
    var film = Film()
    let priority = ["Low","Middle", "High"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var priorityField: UITextField!
    @IBOutlet var directorField: UITextField!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var safeButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        film = DatabaseFilmManager.shared.chosenFilm
        
        setFilm()
    }
    
    func setFilm(){
        titleField.text = film.name
        priorityField.text = priority[film.priority]
        directorField.text = film.director
        commentField.text = film.comment
        
        titleField.isEnabled = false
        priorityField.isEnabled = false
        directorField.isEnabled = false
        commentField.isEditable = false
        
        safeButton.isHidden = true
        
        selectedPriority = film.priority
    }
    
    func editFilm(){
        titleField.isEnabled = true
        priorityField.isEnabled = true
        directorField.isEnabled = true
        commentField.isEditable = true
        
        safeButton.isHidden = false
    }
    
    func createPriorityPicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action:#selector(donePriorityPressed))
        toolbar.setItems([doneButton], animated: true)
        
        priorityField.inputAccessoryView = toolbar
        priorityField.inputView = priorityPicker
    }
    
    @objc func donePriorityPressed(){
        priorityField.text = priority[priorityPicker.selectedRow(inComponent: 0)]
        selectedPriority = priorityPicker.selectedRow(inComponent: 0)
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priority[row]
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if edit{
            edit = false
            setFilm()
        }
        else{
            edit = true
            editFilm()
        }
    }
    
    @IBAction func safeButtonPressed(_ sender: UIButton) {
        errorLabel.isHidden = true
        guard let title = titleField.text else{
            setErrorLabel(error: .noName)
            errorLabel.isHidden = false
            return
        }
        
        guard let comment = commentField.text else{
            return
        }
        
        guard let director = directorField.text else{
            return
        }
        
        guard let selectedPriority = selectedPriority else{
            setErrorLabel(error: .noPriority)
            errorLabel.isHidden = false
            return
        }
        
        film.name = title
        film.comment = comment
        film.director = director
        film.priority = selectedPriority
        
        DatabaseFilmManager.shared.editFilm(film: film)
        self.alertSuccess(sender,true)
        setFilm()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        DatabaseFilmManager.shared.deleteFilm(film: film){ success in
            if success{
                self.alertSuccess(sender, false)
            }
        }
    }
    
    
    func alertSuccess(_ sender: UIButton,_ edit:Bool) {
        
        var title="",message=""
        if edit{
            title = "Film Edited"
            message = "You have successfully edited this film!"
        }
        else{
            title = "Film Deleted"
            message = "You have successfully deleted this film!"
        }
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in _ = self.navigationController?.popViewController(animated: true)}))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    func setErrorLabel(error:DatabaseFilmManager.FilmError){
        switch error {
        case .noName:
            errorLabel.text = "Name requred"
            break
        case .noPriority:
            errorLabel.text = "Priority requred"
            break
        }
    }
}