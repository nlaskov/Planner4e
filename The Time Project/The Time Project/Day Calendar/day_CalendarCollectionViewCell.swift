//
//  CalendarViewControllerCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

class day_CalendarCollectionViewCell: UICollectionViewCell{
    
    
    
    @IBOutlet var category: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var done: UISwitch!
    @IBOutlet var cellView: UIView!
    @IBOutlet var comment: UITextView!
    
    
    func category(category: Int){
        
    }
    func setImportanse(importanse:Int){
        if importanse == 0{
            self.backgroundColor = UIColor.init(red: CGFloat(175 as Double/225), green: CGFloat(227 as Double/225), blue: CGFloat(120 as Double/225), alpha: CGFloat(1))
            
            comment.backgroundColor = UIColor.init(red: CGFloat(175 as Double/225), green: CGFloat(227 as Double/225), blue: CGFloat(120 as Double/225), alpha: CGFloat(1))
        }
        else if importanse == 1 {
            self.backgroundColor =  UIColor.init(red: CGFloat(249 as Double/225), green: CGFloat(219 as Double/225), blue: CGFloat(98 as Double/225), alpha: CGFloat(1))
            comment.backgroundColor = UIColor.init(red: CGFloat(249 as Double/225), green: CGFloat(219 as Double/225), blue: CGFloat(98 as Double/225), alpha: CGFloat(1))
        }
        else {
            self.backgroundColor = UIColor.init(red: CGFloat(249 as Double/225), green: CGFloat(98 as Double/225), blue: CGFloat(125 as Double/225), alpha: CGFloat(1))
            comment.backgroundColor = UIColor.init(red: CGFloat(249 as Double/225), green: CGFloat(98 as Double/225), blue: CGFloat(125 as Double/225), alpha: CGFloat(1))
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
