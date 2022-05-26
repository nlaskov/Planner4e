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
    let priority = ["Low","Middle", "High"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    @IBOutlet var titleField: UITextField!
    @IBOutlet var priorityField: UITextField!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var safeButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        resolution = DatabaseResolutionManager.shared.chosenResolution
        
        setResolution()
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
        if edit{
            title = "Resolution Edited"
            message = "You have successfully edited this resolution!"
        }
        else{
            title = "Resolution Deleted"
            message = "You have successfully deleted this resolution!"
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
