//
//  CalendarViewControllerCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

class day_CalendarCollectionViewCell: UICollectionViewCell{
    
    var task:Tasks? = nil
    
    @IBOutlet var category: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var done: UISwitch!
    @IBOutlet var cellView: UIView!
    @IBOutlet var comment: UITextView!
    
    //Like init
    func setTask(){
        title.text = task?.name
        setSwitch(value: (task?.done ?? false))
        setImportanse(importanse: task?.priority ?? 2)
    }
    
    func category(category: Int){
        
    }
    //Set background color of the view and the comment
    func setImportanse(importanse:Int){
        if importanse == 0{
            self.contentView.backgroundColor = UIColor.init(red: CGFloat(175 as Double/225), green: CGFloat(227 as Double/225), blue: CGFloat(120 as Double/225), alpha: CGFloat(1))
            
            comment.backgroundColor = UIColor.init(red: CGFloat(175 as Double/225), green: CGFloat(227 as Double/225), blue: CGFloat(120 as Double/225), alpha: CGFloat(1))
        }
        else if importanse == 1 {
            self.contentView.backgroundColor =  UIColor.init(red: CGFloat(249 as Double/225), green: CGFloat(219 as Double/225), blue: CGFloat(98 as Double/225), alpha: CGFloat(1))
            comment.backgroundColor = UIColor.init(red: CGFloat(249 as Double/225), green: CGFloat(219 as Double/225), blue: CGFloat(98 as Double/225), alpha: CGFloat(1))
        }
        else {
            self.contentView.backgroundColor = UIColor.init(red: CGFloat(249 as Double/225), green: CGFloat(98 as Double/225), blue: CGFloat(125 as Double/225), alpha: CGFloat(1))
            comment.backgroundColor = UIColor.init(red: CGFloat(249 as Double/225), green: CGFloat(98 as Double/225), blue: CGFloat(125 as Double/225), alpha: CGFloat(1))
        }
    }
    
    //Set the position of the switch and the alpha
    func setSwitch(value:Bool){
        if value {
            done.isOn = true
            self.contentView.alpha = CGFloat(0.4)
            
        }
        else{
            done.isOn = false
            self.contentView.alpha = CGFloat(1)
        }
        comment.isHidden = !done.isOn
    }
    
    //When switch is changed to change the alpha
    @IBAction func changeSwitch(_ sender: Any) {
        comment.isHidden = !done.isOn
        
        if done.isOn {
            UIView.animate(withDuration: 0.5) {
                self.contentView.alpha = CGFloat(0.4)
            }
            task?.done = true
        }
        else{
            UIView.animate(withDuration: 0.5) {
                self.contentView.alpha = CGFloat(1)
            }
            task?.done = false
        }
    }
    
}
