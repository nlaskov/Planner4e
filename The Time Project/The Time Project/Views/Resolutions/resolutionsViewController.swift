//
//  resolutionsViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 21.04.22.
//

import Foundation
import UIKit

class resolutionViewController: UIViewController{
    
    @IBOutlet var viewSegment: UISegmentedControl!
    @IBOutlet var resolutionTable: UITableView!
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSegment.backgroundColor = UIColor(red: 0.59, green: 0.92, blue: 0.82, alpha: 1)
        addButton.backgroundColor = UIColor(red: 0.59, green: 0.92, blue: 0.82, alpha: 1)
        addButton.layer.cornerRadius = 25
        
        resolutionTable.dataSource = self
        resolutionTable.delegate = self
        
        if DatabaseResolutionManager.shared.resolutions_done.isEmpty && DatabaseResolutionManager.shared.resolutions_undone.isEmpty{
            DatabaseResolutionManager.shared.getResolution {
                self.resolutionTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resolutionCheck()
        resolutionTable.reloadData()
    }
    
    func resolutionCheck(){
        var count=0
        
        for item in DatabaseResolutionManager.shared.resolutions_done{
            if item.done == false{
                DatabaseResolutionManager.shared.resolutions_undone.append(item)
                DatabaseResolutionManager.shared.resolutions_done.remove(at: count)
            }
            else{
                count+=1
            }
        }
        
        for item in DatabaseResolutionManager.shared.resolutions_undone{
            if item.done == true{
                DatabaseResolutionManager.shared.resolutions_done.append(item)
                DatabaseResolutionManager.shared.resolutions_undone.remove(at: count)
            }
            else{
                count+=1
            }
        }
    }
    
    @IBAction func changeSegment(_ sender: Any) {
        UIView.animate(withDuration: 0.5){
            self.resolutionTable.alpha = CGFloat(0)
        }
        
        resolutionCheck()
        
        resolutionTable.reloadData()
        
        UIView.animate(withDuration: 0.5){
            self.resolutionTable.alpha = CGFloat(1)
        }
    }
}

extension resolutionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewSegment.selectedSegmentIndex == 0{
            return DatabaseResolutionManager.shared.resolutions_undone.count
        }
        else{
            return DatabaseResolutionManager.shared.resolutions_done.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resolutionCell", for: indexPath) as! resolutionTableViewCell
        
        if viewSegment.selectedSegmentIndex == 0{
            cell.resolution = DatabaseResolutionManager.shared.resolutions_undone[indexPath.row]
            cell.setCell()
        }
        else{
            cell.resolution = DatabaseResolutionManager.shared.resolutions_done[indexPath.row]
            cell.setCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if viewSegment.selectedSegmentIndex == 0{
            DatabaseResolutionManager.shared.chosenResolution = DatabaseResolutionManager.shared.resolutions_undone[indexPath.row]
        }
        else{
            DatabaseResolutionManager.shared.chosenResolution = DatabaseResolutionManager.shared.resolutions_done[indexPath.row]
        }
        
        performSegue(withIdentifier: "toSingleResolution", sender: self)
    }
    
    
}

