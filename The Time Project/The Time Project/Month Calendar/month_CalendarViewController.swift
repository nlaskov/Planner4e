//
//  month_CalendarViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

class month_CalendarViewConroller: UIViewController{
    
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
        setCalendar()
        
        month_collectionView.delegate = self
        month_collectionView.dataSource = self
        
    }
    
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
        }
        setCalendar()
    }
    @IBAction func rightButtoonPress(_ sender: Any) {
        if monthCounter == 0 || monthCounter == -1{
            monthCounter+=1
        }
        setCalendar()
        
        
    }
    
}

extension month_CalendarViewConroller: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

func numberOfSections(in collectionView: UICollectionView) -> Int {
    return weeks
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 7
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath) as! month_CalendarCollectionViewCell
    cell.layer.borderColor = UIColor.black.cgColor
    cell.layer.borderWidth = 0.5
    cell.configureCell(date: items[indexPath.section][indexPath.row])
    return cell
}

func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
    return 0.0
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width / 7.0, height: collectionView.frame.size.height / 7)
}
}

