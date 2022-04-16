//
//  month_CalendarViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

extension CalendarViewController{
    
    
    func setCalendar() {
        let cal = Calendar.current
        let components = (cal as NSCalendar).components([.month, .day,.weekday,.year], from: Date())
        var month = components.month! + monthCounter
        if month == 13{
            month = 1
            yearCounter+=1
        }
        else if month == 0{
            month = 12
            yearCounter-=1
        }
        let year =  components.year! + yearCounter
        let months = dateFormatter.monthSymbols
        let monthSymbol = (months![month-1])
        month_label.text = "\(monthSymbol) \(year)"

        let weekRange = (cal as NSCalendar).range(of: .weekOfMonth, in: .month, for: Date())
        let dateRange = (cal as NSCalendar).range(of: .day, in: .month, for: Date())
        weeks = weekRange.length
        var totalDaysInMonth = dateRange.length
        
        let totalMonthList = weeks * 7
        var dates = [Date]()
        var firstDate = dateFormatter.date(from: "\(year)-\(month)-1")!
        let componentsFromFirstDate = (cal as NSCalendar).components([.month, .day,.weekday,.year], from: firstDate)
        firstDate = (cal as NSCalendar).date(byAdding: [.day], value: -(componentsFromFirstDate.weekday!-1), to: firstDate, options: [])!

        for _ in 1 ... totalMonthList {
            
            
            dates.append(firstDate)
            firstDate = (cal as NSCalendar).date(byAdding: [.day], value: +1, to: firstDate, options: [])!
        }
        let maxCol = 7
        let maxRow = weeks
        items.removeAll(keepingCapacity: false)
        var i = 0

        for _ in 0..<maxRow {
            var colItems = [Date]()
            for _ in 0..<maxCol {
                colItems.append(dates[i])
                i += 1
            }
        items.append(colItems)
        }
        month_collectionView.reloadData()
    }
    
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        if monthCounter == 0 || monthCounter == 1{
            monthCounter-=1
            
            UIView.animate(withDuration: 0.3) {
                self.month_collectionView.alpha = CGFloat(0)
                self.month_label.alpha = CGFloat(0)
            }
            let secondsToDelay = 0.4
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                self.setCalendar()
                UIView.animate(withDuration: 0.3) {
                    self.month_label.alpha = CGFloat(1)
                    self.month_collectionView.alpha = CGFloat(1)
                }
            }
        }
        
        
        
    }
    @IBAction func rightButtoonPress(_ sender: Any) {
        if monthCounter == 0 || monthCounter == -1{
            monthCounter+=1
            
            UIView.animate(withDuration: 0.3) {
                self.month_collectionView.alpha = CGFloat(0)
                self.month_label.alpha = CGFloat(0)
            }
            let secondsToDelay = 0.4
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                self.setCalendar()
                UIView.animate(withDuration: 0.3) {
                    self.month_label.alpha = CGFloat(1)
                    self.month_collectionView.alpha = CGFloat(1)
                }
            }
        }
    }
    
}
