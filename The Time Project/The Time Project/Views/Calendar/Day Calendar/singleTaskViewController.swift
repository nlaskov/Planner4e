//
//  singleTaskViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
import UIKit

class singleTaskViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var priorityField: UITextField!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dateField: UITextField!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var safeButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    var edit = false
    var task = Task()
    let datePicker = UIDatePicker()
    let priorityPicker = UIPickerView()
    let categoryPicker = UIPickerView()
    
    var priority = ["Low","Middle", "High"]
    var category = ["Дом", "Работа", "Пътуване", "Хоби", "Пазаруване","Друго"]
    var selectedCategory:Int? = nil
    var selectedPriority:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLanguage()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        createDatePicker()
        createPriorityPicker()
        createCategortyPicker()
        
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        task = DatabaseTaskManager.shared.chosenTask
        
        setTask()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            priority = ["Нисък","Среден", "Висок"]
            category = ["Дом", "Работа", "Пътуване", "Хоби", "Пазаруване","Друго"]
            
            nameLabel.text = "Име:"
            categoryLabel.text = "Категория:"
            priorityLabel.text = "Приоритет:"
            dateLabel.text = "Дата:"
            commentLabel.text = "Коментар:"
            safeButton.setTitle("Запази", for: .normal)
        }
        else{
            priority = ["Low","Middle", "High"]
            category = ["Home", "Work", "Travel", "Hobby", "Shopping","Others"]
            
            nameLabel.text = "Name:"
            categoryLabel.text = "Category:"
            priorityLabel.text = "Priority:"
            dateLabel.text = "Date:"
            commentLabel.text = "Comment:"
            safeButton.setTitle("Save", for: .normal)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    func setTask(){
        nameField.text = task.name
        priorityField.text = priority[task.priority]
        categoryField.text = category[task.category]
        dateField.text = "\(task.month)/\(task.day)/\(task.year)"
        commentField.text = task.comment
        
        nameField.isEnabled = false
        priorityField.isEnabled = false
        categoryField.isEnabled = false
        dateField.isEnabled = false
        commentField.isEditable = false
        
        safeButton.isHidden = true
        errorLabel.isHidden = true
        
        selectedPriority = task.priority
        selectedCategory = task.category
    }
    
    func editTask(){
        nameField.isEnabled = true
        priorityField.isEnabled = true
        categoryField.isEnabled = true
        dateField.isEnabled = true
        commentField.isEditable = true
        
        safeButton.isHidden = false
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if edit{
            edit = false
            setTask()
        }
        else{
            edit = true
            editTask()
        }
    }
    
    @IBAction func safeButtonPressed(_ sender: UIButton) {
        errorLabel.isHidden = true
        guard let name = nameField.text else{
            setErrorLabel(error: .noName)
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
        
        guard let selectedCategory = selectedCategory else{
            setErrorLabel(error: .noCategory)
            errorLabel.isHidden = false
            return
        }
        
        guard let date = dateField.text else{
            setErrorLabel(error: .noDate)
            errorLabel.isHidden = false
            return
        }
        let intDate = DatabaseTaskManager.shared.getDate(date: date)
        
        task.name = name
        task.priority = selectedPriority
        task.category = selectedCategory
        task.comment = comment
        
        task.day = intDate[0]
        task.month = intDate[1]
        task.year = intDate[2] - 2000
        
        DatabaseTaskManager.shared.editTask(task: task)
        setTask()
        self.alertSuccess(sender, true)
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        DatabaseTaskManager.shared.deleteTask(task: task){success in
            if success{
                self.alertSuccess(sender, false)
            }
            
        }
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
    
    func setErrorLabel(error:DatabaseTaskManager.TaskError){
        if DatabaseUserManager.shared.bg{
            switch error {
            case .noName:
                errorLabel.text = "Трябва име"
                break
            case .noCategory:
                errorLabel.text = "Трябва категория"
                break
            case .noPriority:
                errorLabel.text = "Трябва приоритет"
                break
            case .noDate:
                errorLabel.text = "Трябва дата"
                break
            }
        }
        else{
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
    
    func alertSuccess(_ sender: UIButton,_ edit:Bool) {
        
        var title="",message=""
        if edit && DatabaseUserManager.shared.bg{
            title = "Задача редактирана"
            message = "Успешно редактирахте тази задача!"
        }
        else if !edit && DatabaseUserManager.shared.bg{
            title = "Задача изтрита"
            message = "Успешно изтрихте тази задача!"
        }
        else if edit{
            title = "Task edited"
            message = "You successfully edited this task!"
        }
        else{
            title = "Task Deleted"
            message = "You successfully deleted this task!"
        }
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in _ = self.navigationController?.popViewController(animated: true)}))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
}
