//
//  day_CalendarViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

extension CalendarViewController{
    
    //Press left arrow for the day before
    @IBAction func leftArrowPress(_ sender: Any) {
        
        //Get new date and check if it is too far from today
        used_date = Calendar.current.date(byAdding: .day, value: -1, to: used_date)!
        if dateCheck(date: date, used_date: used_date){
            //If it isn`t too far, get tasks for the day and change the table and lable with animation
            self.getDayTasks();
            //Make them invisible
            UIView.animate(withDuration: 0.5) {
                self.day_CollectionView.alpha = CGFloat(0)
                self.day_dateLabel.alpha = CGFloat(0)
            }
            //Wait until they are invisible and change the data. After that make them visible
            let secondsToDelay = 0.6
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                self.day_dateLabel.text = self.day_setLabelDay(date: self.used_date)
                self.day_CollectionView.reloadData()
                UIView.animate(withDuration: 0.5) {
                    self.day_CollectionView.alpha = CGFloat(1)
                    self.day_dateLabel.alpha = CGFloat(1)
                }
            }
        }
        //If the date is too far don`t change anything
        else{
            used_date = Calendar.current.date(byAdding: .day, value: 1, to: used_date)!
        }
        
        
    }
    //Same as the left arrow but with the next day
    @IBAction func rightArrowPress(_ sender: Any) {
        
        used_date = Calendar.current.date(byAdding: .day, value: 1, to: used_date)!
        if dateCheck(date: date, used_date: used_date){
            self.getDayTasks();
            UIView.animate(withDuration: 0.5) {
                self.day_CollectionView.alpha = CGFloat(0)
                self.day_dateLabel.alpha = CGFloat(0)
            }
            let secondsToDelay = 0.6
            DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                self.day_dateLabel.text = self.day_setLabelDay(date: self.used_date)
                self.day_CollectionView.reloadData()
                UIView.animate(withDuration: 0.5) {
                    self.day_CollectionView.alpha = CGFloat(1)
                    self.day_dateLabel.alpha = CGFloat(1)
                }
            }
            
        }
        else{
            used_date = Calendar.current.date(byAdding: .day, value: -1, to: used_date)!
        }
        
    }
    
    // Make date in the format "weekday, day mon. year"
    func day_setLabelDay(date:Date) -> String{
        
        var temp = ""
        
        switch Calendar.current.component(.weekday, from: date){
        case 1:
            temp += "Sunday, "
        case 2:
            temp += "Monday, "
        case 3:
            temp += "Tuesday, "
        case 4:
            temp += "Wednesday, "
        case 5:
            temp += "Thursday, "
        case 6:
            temp += "Friday, "
        case 7:
            temp += "Saturday, "
        default:
            temp += "Nada, "
        }
        
        temp += String(Calendar.current.component(.day, from: date)) + " "
        
        switch Calendar.current.component(.month, from: date){
        case 1:
            temp += "Jan. "
        case 2:
            temp += "Feb. "
        case 3:
            temp += "Mar. "
        case 4:
            temp += "Apr. "
        case 5:
            temp += "May, "
        case 6:
            temp += "Jun. "
        case 7:
            temp += "Jul. "
        case 8:
            temp += "Aug. "
        case 9:
            temp += "Sep. "
        case 10:
            temp += "Oct. "
        case 11:
            temp += "Nov. "
        case 12:
            temp += "Dec. "
        default:
            temp += "Nada "
        }
        
        temp += String(Calendar.current.component(.year, from: date))
        
        return temp
    }
    
    //Check if given date is too far away from today
    //Too far means that it isn`t in the given month or the one ajesant to him
    func dateCheck(date:Date,used_date:Date) ->Bool {
        let used_month = Calendar.current.component(.month, from: used_date)
        let month = Calendar.current.component(.month, from: date)
        
        if(month != 12 && month != 1){
            if(used_month-month > 1 || used_month-month < -1){
                return false
            }
            else {return true}
        }
        else{
            if((month == 12 && (used_month == 1 || used_month == 11)) || (month == 1 && (used_month == 12 || used_month == 2)) ){
                return true
            }
        }
        return false
    }
    
    //Get array of the tasks for given day
    func getDayTasks(){
        dayTasks.removeAll()
        
        let day = Calendar.current.component(.day, from: used_date)
        let month = Calendar.current.component(.month, from: used_date)
        let year = Calendar.current.component(.year, from: used_date)
        
        for item in database{
            if(item.day == day) && (item.month == month) && (item.year == year){
                dayTasks.append(item)
            }
        }
    }
    
    
    
}
