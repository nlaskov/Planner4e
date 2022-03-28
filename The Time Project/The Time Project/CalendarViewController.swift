//
//  CalendarViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 28.03.22.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController{
    
    @IBOutlet var viewSegment: UISegmentedControl!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var dayCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // CODE
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
    }
    
    var database:[[Any]] = [["Task_1",1,1,false],["Task_2",1,3,true]]
    
    
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return database.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! CalendarViewControllerCell
        
        cell.title.text = database[indexPath.row][0] as? String
        print(database[indexPath.row][0])
        cell.setSwitch(value: database[indexPath.row][3] as! Bool)
        cell.setImportanse(importanse: database[indexPath.row][2] as! Int)
        
        return cell
    }
    
    
}
