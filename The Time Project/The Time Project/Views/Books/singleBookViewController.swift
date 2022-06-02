//
//  singleBookViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
import UIKit

class singleBookViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var edit = false
    var book = Book()
    var priority = ["Low","Middle", "High"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var priorityField: UITextField!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var safeButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLanguage()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        createPriorityPicker()
        
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        book = DatabaseBookManager.shared.chosenBook
        
        setBook()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            priority = ["Нисък","Среден", "Висок"]
            
            titleLabel.text = "Заглавие:"
            priorityLabel.text = "Приоритет:"
            commentLabel.text = "Коментар:"
            safeButton.setTitle("Запази", for: .normal)
        }
        else{
            priority = ["Low","Middle", "High"]
            
            titleLabel.text = "Title:"
            priorityLabel.text = "Priority:"
            commentLabel.text = "Comment:"
            safeButton.setTitle("Save", for: .normal)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    
    func setBook(){
        titleField.text = book.name
        priorityField.text = priority[book.priority]
        
        commentField.text = book.comment
        
        titleField.isEnabled = false
        priorityField.isEnabled = false
        
        commentField.isEditable = false
        
        safeButton.isHidden = true
        errorLabel.isHidden = true
        
        selectedPriority = book.priority
    }
    
    func editBook(){
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
            setBook()
        }
        else{
            edit = true
            editBook()
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
        
        book.name = title
        book.comment = comment
        book.priority = selectedPriority
        
        DatabaseBookManager.shared.editBook(book:book)
        self.alertSuccess(sender,true)
        setBook()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        DatabaseBookManager.shared.deleteBook(book:book){ success in
            if success{
                self.alertSuccess(sender,false)
            }
        }
    }
    
    func alertSuccess(_ sender: UIButton,_ edit:Bool) {
        
        var title="",message=""
        if edit && DatabaseUserManager.shared.bg{
            title = "Книга редактирана"
            message = "Успешно редактирахте тази книга!"
        }
        else if !edit && DatabaseUserManager.shared.bg{
            title = "Книга изтрита"
            message = "Успешно изтрихте тази книга!"
        }
        else if edit{
            title = "Book edited"
            message = "You successfully edited this book!"
        }
        else{
            title = "Book Deleted"
            message = "You successfully deleted this book!"
        }
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in _ = self.navigationController?.popViewController(animated: true)}))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    func setErrorLabel(error:DatabaseBookManager.BookError){
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
