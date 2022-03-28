//
//  day_CalendarViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

class day_CalendarViewConroller: UIViewController{
    
    
    var date: Date = Date()
    var used_date: Date = Date()

    @IBOutlet var day_dateLabel: UILabel!
    @IBOutlet var day_leftButton: UIButton!
    @IBOutlet var day_rightButton: UIButton!
    @IBOutlet var day_CollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        day_CollectionView.dataSource = self
        day_CollectionView.delegate = self
        
        day_dateLabel.text = day_setLabelDay(date: date)
        used_date = date
        
    }
    
    var database:[[Any]] = [["Task_1",1,0,false],["Task_2",1,1,false],["Task_3",1,2,false]]
    
    @IBAction func leftArrowPress(_ sender: Any) {
        
        used_date = Calendar.current.date(byAdding: .day, value: -1, to: used_date)!
        if dateCheck(date: date, used_date: used_date){
            day_dateLabel.text = day_setLabelDay(date: used_date)
        }
        else{
            used_date = Calendar.current.date(byAdding: .day, value: 1, to: used_date)!
        }
        
        
    }
    @IBAction func rightArrowPress(_ sender: Any) {
        
        used_date = Calendar.current.date(byAdding: .day, value: 1, to: used_date)!
        if dateCheck(date: date, used_date: used_date){
            day_dateLabel.text = day_setLabelDay(date: used_date)
        }
        else{
            used_date = Calendar.current.date(byAdding: .day, value: -1, to: used_date)!
        }
        
    }
    
    private func day_setLabelDay(date:Date) -> String{
        
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
    
    private func dateCheck(date:Date,used_date:Date) ->Bool {
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
    
    
    
}

extension day_CalendarViewConroller: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return database.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! day_CalendarCollectionViewCell
        
        cell.title.text = database[indexPath.row][0] as? String
        cell.setSwitch(value: database[indexPath.row][3] as! Bool)
        cell.setImportanse(importanse: database[indexPath.row][2] as! Int)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = database.remove(at: sourceIndexPath.item)
            database.insert(temp, at: destinationIndexPath.item)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }*/
}

