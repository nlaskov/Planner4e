//
//  addFilmViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import UIKit

class addFilmViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let priority = ["Low","Middle", "High"]
    let priorityPicker = UIPickerView()
    var selectedPriority:Int? = nil
    
    @IBOutlet var filmTitle: UITextField!
    @IBOutlet var filmPriority: UITextField!
    @IBOutlet var filmDirector: UITextField!
    @IBOutlet var filmComment: UITextView!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.errorLabel.isHidden = true
        DatabaseFilmManager.shared.addFilm(name: filmTitle.text, priority: selectedPriority, director: filmDirector.text, comment: filmComment.text){ success, error in
            
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
        
        filmPriority.inputAccessoryView = toolbar
        filmPriority.inputView = priorityPicker
    }
    
    @objc func donePriorityPressed(){
        filmPriority.text = priority[priorityPicker.selectedRow(inComponent: 0)]
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
    
    func setErrorLabel(error:DatabaseFilmManager.FilmError){
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


