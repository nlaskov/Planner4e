//
//  booksViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 16.04.22.
//

import Foundation
import UIKit

class booksViewController: UIViewController{
    
    
    
    static public var books_read: [Book] = [Book(_name: "Hunger Games", _priority: 0, _done: true),Book(_name: "Maze Runners", _priority: 1, _done: true),Book(_name: "Harry Potter 1", _priority: 2, _done: true)]
    
    static public var books_unread:[Book] = [Book(_name: "Lord of the rings", _priority: 2, _done: false),Book(_name: "Dune", _priority: 1, _done: false)]
    
    @IBOutlet var bookTable: UITableView!
    @IBOutlet var viewSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTable.dataSource = self
        bookTable.delegate = self
    }
    
    @IBAction func changeSegment(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.bookTable.alpha = CGFloat(0)
        }
        
        bookTable.reloadData()
        
        UIView.animate(withDuration: 0.5) {
            self.bookTable.alpha = CGFloat(1)
        }
    }
    
    
    
    
}
extension booksViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewSegment.selectedSegmentIndex == 0{
            return booksViewController.books_unread.count
        }
        else{
            return booksViewController.books_read.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! bookTableViewCell
        
        if viewSegment.selectedSegmentIndex == 0{
            cell.book = booksViewController.books_unread[indexPath.row]
            cell.setCell()
        }
        else{
            cell.book = booksViewController.books_read[indexPath.row]
            cell.setCell()
        }
        
        return cell
    }
    
    
}
