//
//  addTaskViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import UIKit

class addTaskViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var priorityField: UITextField!
    @IBOutlet var categoryField: UITextField!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var errorLabel: UILabel!
    
    let datePicker = UIDatePicker()
    let priorityPicker = UIPickerView()
    let categoryPicker = UIPickerView()
    
    let priority = ["Low","Middle", "High"]
    let category = ["I", "do", "not", "know", "what", "categories", "we", "will", "use", ":)"]
    var selectedCategory:Int? = nil
    var selectedPriority:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        createPriorityPicker()
        createCategortyPicker()
        
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
    }
    func createDatePicker(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePressed))
        toolbar.setItems([doneButton], animated: true)
        
        dateField.inputAccessoryView = toolbar
        
        dateField.inputView = datePicker
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    func createPriorityPicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action:#selector(donePriorityPressed))
        toolbar.setItems([doneButton], animated: true)
        
        priorityField.inputAccessoryView = toolbar
        priorityField.inputView = priorityPicker
    }
    
    func createCategortyPicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action:#selector(doneCategoryPressed))
        toolbar.setItems([doneButton], animated: true)
        
        categoryField.inputAccessoryView = toolbar
        categoryField.inputView = categoryPicker
    }
    
    @objc func doneDatePressed(){
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        dateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func donePriorityPressed(){
        priorityField.text = priority[priorityPicker.selectedRow(inComponent: 0)]
        selectedPriority = priorityPicker.selectedRow(inComponent: 0)
        self.view.endEditing(true)
    }
    
    @objc func doneCategoryPressed(){
        categoryField.text = category[categoryPicker.selectedRow(inComponent: 0)]
        selectedCategory = categoryPicker.selectedRow(inComponent: 0)
        self.view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == priorityPicker{
            return 3
        }
        else {
            return category.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == priorityPicker{
            return priority[row]
        }
        else {
            return category[row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        DatabaseTaskManager.shared.addTask(name: nameField.text, priority: selectedPriority, category: selectedCategory, date: dateField.text, comment: commentField.text){success,error in
            
            if success{
                _ = self.navigationController?.popViewController(animated: true)
                
            }
            else{
                self.setErrorLabel(error: error!)
                self.errorLabel.isHidden = false
            }
        }
    }
    
    func setErrorLabel(error:DatabaseTaskManager.TaskError){
        switch error {
        case .noName:
            errorLabel.text = "Name requred"
            break
        case .noCategory:
            errorLabel.text = "Category requred"
            break
        case .noPriority:
            errorLabel.text = "Priority requred"
            break
        case .noDate:
            errorLabel.text = "Date requred"
            break
        }
    }
    
    
}
