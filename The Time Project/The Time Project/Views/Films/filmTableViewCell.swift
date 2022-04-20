//
//  filmTableViewCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation

import Foundation
import UIKit

class filmTableViewCell:UITableViewCell{
    var film:Film? = nil
    
    @IBOutlet var importance: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var done: UISwitch!
    
    func setCell(){
        
        switch film?.priority{
        case 0:
            importance.tintColor = UIColor.init(red: CGFloat(175 as Double/225), green: CGFloat(227 as Double/225), blue: CGFloat(120 as Double/225), alpha: CGFloat(1))
            break
        case 1:
            importance.tintColor = UIColor.init(red: CGFloat(249 as Double/225), green: CGFloat(219 as Double/225), blue: CGFloat(98 as Double/225), alpha: CGFloat(1))
            break
        case 2:
            importance.tintColor = UIColor.init(red: CGFloat(249 as Double/225), green: CGFloat(98 as Double/225), blue: CGFloat(125 as Double/225), alpha: CGFloat(1))
            break
        default:
            break
        }
        
        title.text = film?.name
        if film?.done ?? false{
            done.isOn = true
        }
        else {
            done.isOn = false
        }
    }
    
    
    @IBAction func changeSwitch(_ sender: Any) {
        if done.isOn == true{
            film?.done = true
        }
        else {
            film?.done = false
        }
    }
    
}
