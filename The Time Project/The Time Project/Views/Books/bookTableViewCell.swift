//
//  bookTableViewCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 16.04.22.
//

import Foundation
import UIKit

class bookTableViewCell:UITableViewCell{
    var book:Book = Book()
    
    
    @IBOutlet var importance: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var done: UISwitch!
    
    func setCell(){
        
        switch book.priority{
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
        
        title.text = book.name
        if book.done{
            done.isOn = true
        }
        else {
            done.isOn = false
        }
    }
    @IBAction func doneSwitch(_ sender: Any) {
        if done.isOn == true{
            book.done = true
        }
        else {
            book.done = false
        }
        DatabaseBookManager.shared.editBook(book: book)
    }
}
