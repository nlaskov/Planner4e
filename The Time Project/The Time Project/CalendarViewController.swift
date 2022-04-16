//
//  CalendarViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController{
   
    //ToAll
    @IBOutlet var viewSegment: UISegmentedControl!
    @IBOutlet var addTaskButton: UIButton!
    
    @IBOutlet var monthView: UIView!
    @IBOutlet var dayView: UIView!
    
    //DAY
    var date: Date = Date()
    var used_date: Date = Date()
    var dayTasks: [Tasks] = []

    @IBOutlet var day_dateLabel: UILabel!
    @IBOutlet var day_leftButton: UIButton!
    @IBOutlet var day_rightButton: UIButton!
    @IBOutlet var day_CollectionView: UICollectionView!
    
    var database:[Tasks] = [Tasks.init(_name: "Task_1", _priority: 0, _category: 1, _day: 15, _month: 4, _year: 2022, _done: false),Tasks.init(_name: "Task_2", _priority: 1, _category: 1, _day: 29, _month: 3, _year: 2022, _done: false),Tasks.init(_name: "Task_3", _priority: 2, _category: 1, _day: 30, _month: 3, _year: 2022, _done: true),Tasks.init(_name: "Task_4", _priority: 2, _category: 1, _day: 29, _month: 3, _year: 2022, _done: true)]
    
    
    
    //Month
    @IBOutlet var month_LeftButton: UIButton!
    @IBOutlet var month_RightButton: UIButton!
    @IBOutlet var month_collectionView: UICollectionView!
    @IBOutlet var month_label: UILabel!
    var weeks = 0
    var monthCounter = 0
    var yearCounter = 0
    var items = [[Date]]()
    lazy var dateFormatter: DateFormatter = {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To All
        viewSegment.backgroundColor = UIColor(red: 0.59, green: 0.92, blue: 0.82, alpha: 1)
        addTaskButton.backgroundColor = UIColor(red: 0.59, green: 0.92, blue: 0.82, alpha: 1)
        //addTaskButton.setTitleColor(.black, for: .normal)
        addTaskButton.layer.cornerRadius=25
        
        monthView.alpha = CGFloat(0)
        dayView.alpha = CGFloat(1)
        
        //Day
        day_CollectionView.dataSource = self
        day_CollectionView.delegate = self
        day_dateLabel.text = day_setLabelDay(date: date)
        used_date = date
        self.getDayTasks();
        
        //Month
        month_collectionView.delegate = self
        month_collectionView.dataSource = self
        setCalendar()
        
    }
    //Change between dayView, weekView and monthView
    @IBAction func segmentChange(_ sender: Any) {
        changeSegment(viewSegment.selectedSegmentIndex)
    }
    
    func changeSegment(_ value:Int){
        if value == 0{
            UIView.animate(withDuration: 0.5) {
                //self.weekView.alpha = CGFloat(0)
                self.monthView.alpha = CGFloat(0)
                self.dayView.alpha = CGFloat(1)
                
                
            }
            
        }else if value == 1{
            UIView.animate(withDuration: 0.5) {
                //self.weekView.alpha = CGFloat(1)
                self.dayView.alpha = CGFloat(0)
                self.monthView.alpha = CGFloat(0)
            }
        }
        else{
            UIView.animate(withDuration: 0.5) {
                //self.weekView.alpha = CGFloat(0)
                self.dayView.alpha = CGFloat(0)
                self.monthView.alpha = CGFloat(1)
            }
        }
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == day_CollectionView{
            return 1
        }else{
            return weeks
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == day_CollectionView{
            return dayTasks.count
        }else{
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == day_CollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! day_CalendarCollectionViewCell
            
            cell.task = dayTasks[indexPath.row]
            cell.setTask()
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath) as! month_CalendarCollectionViewCell
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 0.5
            cell.configureCell(date: items[indexPath.section][indexPath.row])
            
            let cal = Calendar.current
            let components = (cal as NSCalendar).components([.month, .day,.weekday,.year], from: items[indexPath.section][indexPath.row])
            let components1 = (cal as NSCalendar).components([.month, .day,.weekday,.year], from: date)
            
            if components.month != components1.month! + monthCounter {
                cell.isHidden=true
            }
            else {
                cell.isHidden=false
            }
            
            
            if(indexPath.row == 0 || indexPath.row == 6){
                cell.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
            }
            else{
                cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        if collectionView == day_CollectionView{
            return 10.0
        }else{
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == day_CollectionView{
            return CGSize(width: 386.0 , height: 63.0)
        }else{
            return CGSize(width: collectionView.frame.size.width / 7.0, height: collectionView.frame.size.height / 7)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        if collectionView == day_CollectionView{
            
        }else{
            let cell = collectionView.cellForItem(at: indexPath) as! month_CalendarCollectionViewCell
            let cal = Calendar.current
            let components = (cal as NSCalendar).components([.month, .day,.weekday,.year], from: cell.date)
           
            used_date = (cal as NSCalendar).date(from:components)!
            
            if dateCheck(date: date, used_date: used_date){
                self.getDayTasks();
                self.day_dateLabel.text = self.day_setLabelDay(date: self.used_date)
                self.day_CollectionView.reloadData()
                changeSegment(0)
                viewSegment.selectedSegmentIndex=0
            }
        }
    }
}



