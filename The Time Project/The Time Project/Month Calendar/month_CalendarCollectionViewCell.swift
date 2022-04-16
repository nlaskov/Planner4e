//
//  month_CalendarCollectionViewCell.swift
//  The Time Project
//
//  Created by Nikola Laskov on 15.04.22.
//

import Foundation
import UIKit
class month_CalendarCollectionViewCell: UICollectionViewCell {

    var date: Date!

    @IBOutlet weak var lblDate: UILabel!

    func configureCell(date: Date){
        self.date = date
        let cal = Calendar.current
        let components = (cal as NSCalendar).components([.day], from: date)
        let day = components.day!
        
        self.lblDate.text = "\(String(describing: day))"
    }
}
