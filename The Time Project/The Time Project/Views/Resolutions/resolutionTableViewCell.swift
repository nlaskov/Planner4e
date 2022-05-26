//
//  resolutionTableViewCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
import UIKit

class resolutionTableViewCell:UITableViewCell{
    var resolution:Resolution = Resolution()
    
    
    @IBOutlet var importance: UIImageView!
    @IBOutlet var done: UISwitch!
    @IBOutlet var title: UILabel!
    
    func setCell(){
        switch resolution.priority{
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
        
        title.text = resolution.name
        done.isOn = resolution.done
    }
    
    @IBAction func doneSwitch(_ sender: Any) {
        resolution.done = done.isOn
        
        DatabaseResolutionManager.shared.editResolution(resolution: resolution)
    }
    
}
