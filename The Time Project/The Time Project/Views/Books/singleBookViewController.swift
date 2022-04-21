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
    let priority = ["Low","Middle", "High"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var priorityField: UITextField!
    @IBOutlet var authorField: UITextField!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var safeButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        book = DatabaseBookManager.shared.chosenBook
        
        setBook()
    }
    
    
    func setBook(){
        titleField.text = book.name
        priorityField.text = priority[book.priority]
        authorField.text = book.author
        commentField.text = book.comment
        
        titleField.isEnabled = false
        priorityField.isEnabled = false
        authorField.isEnabled = false
        commentField.isEditable = false
        
        safeButton.isHidden = true
        
        selectedPriority = book.priority
    }
    
    func editBook(){
        titleField.isEnabled = true
        priorityField.isEnabled = true
        authorField.isEnabled = true
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
        
        guard let author = authorField.text else{
            setErrorLabel(error: .noAuthor)
            errorLabel.isHidden = false
            return
        }
        
        guard let selectedPriority = selectedPriority else{
            setErrorLabel(error: .noPriority)
            errorLabel.isHidden = false
            return
        }
        
        book.name = title
        book.comment = comment
        book.author = author
        book.priority = selectedPriority
        
        DatabaseBookManager.shared.EditBook(book:book)
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
        if edit{
            title = "Book Edited"
            message = "You have successfully edited this book!"
        }
        else{
            title = "Book Deleted"
            message = "You have successfully deleted this book!"
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
        switch error {
        case .noName:
            errorLabel.text = "Name requred"
            break
        case .noAuthor:
            errorLabel.text = "Author requred"
            break
        case .noPriority:
            errorLabel.text = "Priority requred"
            break
        }
    }
    
}
