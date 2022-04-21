//
//  addBookViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import UIKit

class addBookViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let priority = ["Low","Middle", "High"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    
    @IBOutlet var bookTitle: UITextField!
    @IBOutlet var bookPriority: UITextField!
    @IBOutlet var bookComment: UITextView!
    @IBOutlet var bookAuthor: UITextField!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        createPriorityPicker()
        
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        DatabaseBookManager.shared.addBook(name: bookTitle.text, priority: selectedPriority,author: bookAuthor.text,comment: bookComment.text){ success,error in
            
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
