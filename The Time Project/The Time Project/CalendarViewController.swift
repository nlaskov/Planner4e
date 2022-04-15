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
    @IBOutlet var addTaskButton: UIButton!
    
    @IBOutlet var dayView: UIView!
    @IBOutlet var weekView: UIView!
    @IBOutlet var monthView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CODE
        
        viewSegment.backgroundColor = UIColor(red: 0.59, green: 0.92, blue: 0.82, alpha: 1)
        addTaskButton.backgroundColor = UIColor(red: 0.59, green: 0.92, blue: 0.82, alpha: 1)
        //addTaskButton.setTitleColor(.black, for: .normal)
        addTaskButton.layer.cornerRadius=25
        
    }
    
    
    
    
    //Change between dayView, weekView and monthView
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

