//
//  CalendarViewControllerCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

class CalendarViewControllerCell: UICollectionViewCell{
    
    
    
    @IBOutlet var category: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var done: UISwitch!
    @IBOutlet var cellView: UIView!
    @IBOutlet var comment: UITextView!
    
    
    func category(category: Int){
        
    }
    func setImportanse(importanse:Int){
        if importanse == 0{
            self.backgroundColor = .green
            comment.backgroundColor = .green
        }
        else if importanse == 1 {
            self.backgroundColor = .yellow
            comment.backgroundColor = .yellow
        }
        else {
            self.backgroundColor = .red
            comment.backgroundColor = .red
        }
    }
    func setSwitch(value:Bool){
        if value {
            done.isOn = true
            UIView.animate(withDuration: 0.5) {
                self.alpha = CGFloat(0.4)
            }
            
        }
        else{
            done.isOn = false
            UIView.animate(withDuration: 0.5) {
                self.alpha = CGFloat(1)
            }
        }
        comment.isHidden = !done.isOn
    }
    @IBAction func changeSwitch(_ sender: Any) {
        comment.isHidden = !done.isOn
        
        if done.isOn {
            UIView.animate(withDuration: 0.5) {
                self.alpha = CGFloat(0.4)
            }
        }
        else{
            UIView.animate(withDuration: 0.5) {
                self.alpha = CGFloat(1)
            }
        }
    }
    
}
