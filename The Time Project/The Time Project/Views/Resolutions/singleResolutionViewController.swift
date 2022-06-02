//
//  singleResolutionViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
import UIKit

class singleResolutionViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var edit = false
    var resolution = Resolution()
    var priority = ["Нисък","Среден", "Висок"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priorityField: UITextField!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var safeButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguage()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        createPriorityPicker()
        
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        resolution = DatabaseResolutionManager.shared.chosenResolution
        
        setResolution()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            priority = ["Нисък","Среден", "Висок"]
            titleLabel.text = "Име:"
            priorityLabel.text = "Приоритет:"
            commentLabel.text = "Коментар:"
            safeButton.setTitle("Запази", for: .normal)
        }
        else{
            priority = ["Low","Middle", "High"]
            titleLabel.text = "Name:"
            priorityLabel.text = "Priority:"
            commentLabel.text = "Comment:"
            safeButton.setTitle("Save", for: .normal)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    func setResolution(){
        titleField.text = resolution.name
        priorityField.text = priority[resolution.priority]
        commentField.text = resolution.comment
        
        titleField.isEnabled = false
        priorityField.isEnabled = false
        commentField.isEditable = false
        
        safeButton.isHidden = true
        errorLabel.isHidden = true
        
        selectedPriority = resolution.priority
    }
    
    func editResolution(){
        titleField.isEnabled = true
        priorityField.isEnabled = true
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
            setResolution()
        }
        else{
            edit = true
            editResolution()
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
        
        guard let selectedPriority = selectedPriority else{
            setErrorLabel(error: .noPriority)
            errorLabel.isHidden = false
            return
        }
        
        resolution.name = title
        resolution.comment = comment
        resolution.priority = selectedPriority
        
        DatabaseResolutionManager.shared.editResolution(resolution: resolution)
        self.alertSuccess(sender,true)
        setResolution()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        DatabaseResolutionManager.shared.deleteResolution(resolution: resolution){ success in
            if success{
                self.alertSuccess(sender,false)
            }
        }
    }
    
    func alertSuccess(_ sender: UIButton,_ edit:Bool) {
        
        var title="",message=""
        if edit && DatabaseUserManager.shared.bg{
            title = "Цел редактирана"
            message = "Успешно редактирахте тази цел!"
        }
        else if !edit && DatabaseUserManager.shared.bg{
            title = "Цел изтрита"
            message = "Успешно изтрихте тази цел!"
        }
        else if edit{
            title = "Resolution edited"
            message = "You successfully edited this resolution!"
        }
        else{
            title = "Resolution Deleted"
            message = "You successfully deleted this resolution!"
        }
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in _ = self.navigationController?.popViewController(animated: true)}))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    func setErrorLabel(error:DatabaseResolutionManager.ResolutionError){
        if DatabaseUserManager.shared.bg{
            switch error {
            case .noName:
                errorLabel.text = "Трябва име"
                break
            case .noPriority:
                errorLabel.text = "Трябва приоритет"
                break
            }
        }
        else{
            switch error {
            case .noName:
                errorLabel.text = "Name required"
                break
            case .noPriority:
                errorLabel.text = "Priority required"
                break
            }
        }
        
    }
    
    
}
