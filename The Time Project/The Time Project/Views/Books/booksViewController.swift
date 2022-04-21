//
//  booksViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 16.04.22.
//

import Foundation
import UIKit

class booksViewController: UIViewController{
    
    @IBOutlet var bookTable: UITableView!
    @IBOutlet var viewSegment: UISegmentedControl!
    @IBOutlet var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        viewSegment.backgroundColor = UIColor(red: 0.59, green: 0.92, blue: 0.82, alpha: 1)
        addButton.backgroundColor = UIColor(red: 0.59, green: 0.92, blue: 0.82, alpha: 1)
        addButton.layer.cornerRadius=25
        
        bookTable.dataSource = self
        bookTable.delegate = self
        
        if DatabaseBookManager.shared.books_read.isEmpty && DatabaseBookManager.shared.books_unread.isEmpty{
            DatabaseBookManager.shared.getBooks(){
                self.bookTable.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bookCheck()
        bookTable.reloadData();
    }
    
    func bookCheck(){
        var count=0
        
        for item in DatabaseBookManager.shared.books_read{
            if item.done == false{
                DatabaseBookManager.shared.books_unread.append(item)
                DatabaseBookManager.shared.books_read.remove(at: count)
            }
            else{
                count+=1
            }
        }
        
        for item in DatabaseBookManager.shared.books_unread{
            if item.done == true{
                DatabaseBookManager.shared.books_read.append(item)
                DatabaseBookManager.shared.books_unread.remove(at: count)
            }
            else{
                count+=1
            }
        }
    }
    
    @IBAction func changeSegment(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.bookTable.alpha = CGFloat(0)
        }
        
        bookCheck()
        
        bookTable.reloadData()
        
        UIView.animate(withDuration: 0.5) {
            self.bookTable.alpha = CGFloat(1)
        }
    }
    
    
}
extension booksViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewSegment.selectedSegmentIndex == 0{
            
            return DatabaseBookManager.shared.books_unread.count
            
        }
        else{
            
            return DatabaseBookManager.shared.books_read.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! bookTableViewCell
        
        if viewSegment.selectedSegmentIndex == 0{
            cell.book = DatabaseBookManager.shared.books_unread[indexPath.row]
            cell.setCell()
        }
        else{
            cell.book = DatabaseBookManager.shared.books_read[indexPath.row]
            cell.setCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewSegment.selectedSegmentIndex == 0{
            DatabaseBookManager.shared.chosenBook = DatabaseBookManager.shared.books_unread[indexPath.row]
        }
        else{
            DatabaseBookManager.shared.chosenBook = DatabaseBookManager.shared.books_read[indexPath.row]
        }
        
        performSegue(withIdentifier: "toSingleBook", sender: self)
    }
    
    
}
