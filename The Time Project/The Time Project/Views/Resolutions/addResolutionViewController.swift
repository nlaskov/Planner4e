//
//  addResolutionViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
import UIKit

class addResolutionViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var priority = ["Нисък","Среден", "Висок"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    
    @IBOutlet var titleField: UITextField!
    
    @IBOutlet var priorityField: UITextField!
    @IBOutlet var commentField: UITextView!
    
    @IBOutlet var safeButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        createPriorityPicker()
        
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            priority = ["Нисък","Среден", "Висок"]
            titleLabel.text = "Добави цел"
            titleField.placeholder = "Име"
            priorityField.placeholder = "Приоритет"
            commentLabel.text = "Коментар:"
            safeButton.setTitle("Запази", for: .normal)
        }
        else{
            priority = ["Low", "Middle", "High"]
            titleLabel.text = "Add Resolution"
            titleField.placeholder = "Name"
            priorityField.placeholder = "Priority"
            commentLabel.text = "Comment:"
            safeButton.setTitle("Save", for: .normal)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @IBAction func safeButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        DatabaseResolutionManager.shared.addResolution(name: titleField.text, priority: selectedPriority, comment: commentField.text){ success, error in
            
            if success{
                _ = self.navigationController?.popViewController(animated: true)
            }
            else{
                self.setErrorLabel(error: error!)
                self.errorLabel.isHidden = false
            }
        }
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
    
    func setErrorLabel(error:DatabaseResolutionManager.ResolutionError){
        if DatabaseUserManager.shared.bg{
            switch error {
            case .noName:
                errorLabel.text = "Трябва име."
                break
            case .noPriority:
                errorLabel.text = "Трябва приоритет."
                break
            }
        }
        else{
            switch error {
            case .noName:
                errorLabel.text = "Name required."
                break
            case .noPriority:
                errorLabel.text = "Priority required."
                break
            }
        }
        
    }
}
