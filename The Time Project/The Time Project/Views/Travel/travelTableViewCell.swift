//
//  travelTabelViewCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 2.06.22.
//

import Foundation
import UIKit

class travelTableViewCell:UITableViewCell{
    var destination:Destination = Destination()
    
    @IBOutlet var importance: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var checkButton: UIImageView!
    
    func setCell(){
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        checkButton.addGestureRecognizer(tapGR)
        checkButton.isUserInteractionEnabled = true
        
        switch destination.priority{
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
        
        title.text = destination.name
        if destination.done{
            checkButton.image = UIImage(named: "Checkmark")
        }
        else {
            checkButton.image = UIImage(named: "Checkmarkempty")
        }
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if destination.done == true{
                destination.done = false
                checkButton.image = UIImage(named: "Checkmarkempty")
            }
            else {
                destination.done = true
                checkButton.image = UIImage(named: "Checkmark")
            }
            DatabaseTravelManager.shared.editDestination(destination: destination)
        }
    }
    
}
