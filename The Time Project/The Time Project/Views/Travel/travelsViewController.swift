//
//  travelsViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 2.06.22.
//

import Foundation
import UIKit

class travelViewController: UIViewController{
    
    @IBOutlet var viewSegment: UISegmentedControl!
    @IBOutlet var travelTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        travelTable.dataSource = self
        travelTable.delegate = self
        
        if DatabaseTravelManager.shared.unvisited.isEmpty && DatabaseTravelManager.shared.visited.isEmpty{
            DatabaseTravelManager.shared.getDestinations {
                self.travelTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        travelCheck()
        DatabaseTravelManager.shared.sortDestinations()
        travelTable.reloadData()
        setLanguage()
    }
    
    func setLanguage(){
        if DatabaseUserManager.shared.bg{
            viewSegment.setTitle("Да посетя", forSegmentAt: 0)
            viewSegment.setTitle("Посетени", forSegmentAt: 1)
            viewSegment.setTitle("Багажи", forSegmentAt: 2)
        }
        else{
            viewSegment.setTitle("To visit", forSegmentAt: 0)
            viewSegment.setTitle("Visited", forSegmentAt: 1)
            viewSegment.setTitle("Bagage", forSegmentAt: 2)
        }
    }
    
    func travelCheck(){
        var count=0
        
        for item in DatabaseTravelManager.shared.visited{
            if item.done == false{
                DatabaseTravelManager.shared.unvisited.append(item)
                DatabaseTravelManager.shared.visited.remove(at: count)
            }
            else{
                count += 1
            }
        }
        count = 0
        for item in DatabaseTravelManager.shared.unvisited{
            if item.done == true{
                DatabaseTravelManager.shared.visited.append(item)
                DatabaseTravelManager.shared.unvisited.remove(at: count)
            }
            else{
                count += 1
            }
        }
    }
    
    @IBAction func changeSegment(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.travelTable.alpha = CGFloat(0)
        }
        
        travelCheck()
        travelTable.reloadData()
        
        UIView.animate(withDuration: 0.5) {
            self.travelTable.alpha = CGFloat(1)
        }
    }
}
extension travelViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewSegment.selectedSegmentIndex == 0{
            
            return DatabaseTravelManager.shared.unvisited.count
            
        }
        else{
            
            return DatabaseTravelManager.shared.visited.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell", for: indexPath) as! travelTableViewCell
        
        if viewSegment.selectedSegmentIndex == 0{
            cell.destination = DatabaseTravelManager.shared.unvisited[indexPath.row]
            cell.setCell()
        }
        else{
            cell.destination = DatabaseTravelManager.shared.visited[indexPath.row]
            cell.setCell()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewSegment.selectedSegmentIndex == 0{
            DatabaseTravelManager.shared.chosenDestnation = DatabaseTravelManager.shared.unvisited[indexPath.row]
        }
        else{
            DatabaseTravelManager.shared.chosenDestnation = DatabaseTravelManager.shared.visited[indexPath.row]
        }
        
        performSegue(withIdentifier: "toSingleDestination", sender: self)
    }
    
    
}
