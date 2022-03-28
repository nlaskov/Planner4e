//
//  CalendarViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController{
    
    var counter = 0
    
    @IBOutlet var viewSegment: UISegmentedControl!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var dayCollectionView: UICollectionView!
    @IBOutlet var dayView: UIView!
    @IBOutlet var weekView: UIView!
    @IBOutlet var monthView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // CODE
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
    }
    
    var database:[[Any]] = [["Task_1",1,0,false],["Task_2",1,1,false],["Task_3",1,2,false]]
    
    @IBAction func segmentChange(_ sender: Any) {
        if viewSegment.selectedSegmentIndex == 0{
            UIView.animate(withDuration: 0.5) {
                self.weekView.alpha = CGFloat(0)
                self.monthView.alpha = CGFloat(0)
                self.dayView.alpha = CGFloat(1)
            }
            
        }else if viewSegment.selectedSegmentIndex == 1{
            UIView.animate(withDuration: 0.5) {
                self.weekView.alpha = CGFloat(1)
                self.dayView.alpha = CGFloat(0)
                self.monthView.alpha = CGFloat(0)
            }
        }
        else{
            UIView.animate(withDuration: 0.5) {
                self.weekView.alpha = CGFloat(0)
                self.dayView.alpha = CGFloat(0)
                self.monthView.alpha = CGFloat(1)
            }
        }
    }
    
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return database.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! CalendarViewControllerCell
        
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
