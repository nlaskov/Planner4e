//
//  filmTableViewCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import UIKit

class filmTableViewCell:UITableViewCell{
    var film:Film = Film()
    
    @IBOutlet var importance: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var done: UISwitch!
    @IBOutlet var checkButton: UIImageView!
    
    func setCell(){
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        checkButton.addGestureRecognizer(tapGR)
        checkButton.isUserInteractionEnabled = true
        
        switch film.priority{
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
        
        title.text = film.name
        if film.done{
            checkButton.image = UIImage(named: "Checkmark")
        }
        else{
            checkButton.image = UIImage(named: "Checkmarkempty")
        }
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if film.done == true{
                film.done = false
                checkButton.image = UIImage(named: "Checkmarkempty")
            }
            else {
                film.done = true
                checkButton.image = UIImage(named: "Checkmark")
            }
            DatabaseFilmManager.shared.editFilm(film: film)
        }
    }
    
}
