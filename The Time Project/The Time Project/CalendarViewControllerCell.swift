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
    
    
    func category(category: Int){
        
    }
    func setImportanse(importanse:Int){
        if importanse == 0{
            cellView.backgroundColor = .green
        }
        else if importanse == 1 {
            cellView.backgroundColor = .yellow
        }
        else {
            cellView.backgroundColor = .red
        }
    }
    func setSwitch(value:Bool){
        if value {
            done.isOn = true
        }
        else{
            done.isOn = false
        }
    }
}
