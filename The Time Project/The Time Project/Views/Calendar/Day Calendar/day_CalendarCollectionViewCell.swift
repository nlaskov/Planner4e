//
//  CalendarViewControllerCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

class day_CalendarCollectionViewCell: UICollectionViewCell{
    
    var task:Task? = nil
    
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var done: UISwitch!
    @IBOutlet var cellView: UIView!
    @IBOutlet var comment: UITextView!
    
    //Like init
    func setCell(){
        title.text = task?.name
        setSwitch(value: (task?.done ?? false))
        setImportanse(importanse: task?.priority ?? 2)
        setCategory(category: task?.category ?? 5)
    }
    
    func setCategory(category: Int){
        switch category{
        case 0:
            categoryImage.image = UIImage(named: "icons8-homebrew-50")
            break
        case 1:
            categoryImage.image = UIImage(named: "icons8-business-50")
            break
        case 2:
            categoryImage.image = UIImage(named: "icons8-aircraft-50")
            break
        case 3:
            categoryImage.image = UIImage(named: "icons8-drawing-50")
            break
        case 4:
            categoryImage.image = UIImage(named: "icons8-add-shopping-cart-50")
            break
        default:
            categoryImage.image = UIImage(named: "icons8-cow-50")
            break
        }
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
