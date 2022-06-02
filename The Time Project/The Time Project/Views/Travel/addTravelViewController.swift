//
//  addTravelViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 2.06.22.
//

import Foundation
import UIKit

class addTravelViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    var priority = ["Low","Middle", "High"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    
    @IBOutlet var travelTitle: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var travelPriority: UITextField!
    @IBOutlet var CommentLabel: UILabel!
    @IBOutlet var travelComment: UITextView!
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
            
            titleLabel.text = "Добави дестинация"
            travelTitle.placeholder = "Име"
            travelPriority.placeholder = "Приоритет"
            CommentLabel.text = "Коментар:"
            addButton.setTitle("Запази", for: .normal)
        }
        else{
            priority = ["Low","Middle", "High"]
            
            titleLabel.text = "Add Destination"
            travelTitle.placeholder = "Name"
            travelPriority.placeholder = "Priority"
            CommentLabel.text = "Comment:"
            addButton.setTitle("Save", for: .normal)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        DatabaseTravelManager.shared.addDestination(name: travelTitle.text, priority: selectedPriority, comment: travelComment.text){ success,error in
            
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
        
        travelPriority.inputAccessoryView = toolbar
        travelPriority.inputView = priorityPicker
    }
    
    @objc func donePriorityPressed(){
        travelPriority.text = priority[priorityPicker.selectedRow(inComponent: 0)]
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
    
    func setErrorLabel(error:DatabaseTravelManager.TravelError){
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
