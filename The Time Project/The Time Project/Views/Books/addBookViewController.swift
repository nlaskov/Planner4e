//
//  addBookViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import UIKit

class addBookViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var priority = ["Low","Middle", "High"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bookTitle: UITextField!
    @IBOutlet var bookPriority: UITextField!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var bookComment: UITextView!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
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
            
            titleLabel.text = "Добави книга"
            bookTitle.placeholder = "Заглавие"
            bookPriority.placeholder = "Приоритет"
            commentLabel.text = "Коментар:"
            addButton.setTitle("Запази", for: .normal)
        }
        else{
            priority = ["Low","Middle", "High"]
            
            titleLabel.text = "Add Book"
            bookTitle.placeholder = "Title"
            bookPriority.placeholder = "Priority"
            commentLabel.text = "Comment:"
            addButton.setTitle("Save", for: .normal)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        DatabaseBookManager.shared.addBook(name: bookTitle.text, priority: selectedPriority,comment: bookComment.text){ success,error in
            
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
        
        bookPriority.inputAccessoryView = toolbar
        bookPriority.inputView = priorityPicker
    }
    
    @objc func donePriorityPressed(){
        bookPriority.text = priority[priorityPicker.selectedRow(inComponent: 0)]
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
                errorLabel.text = "Name requred"
                break
            case .noPriority:
                errorLabel.text = "Priority requred"
                break
            }
        }
    }
}
