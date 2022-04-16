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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        bookTable.dataSource = self
        bookTable.delegate = self
        
        DatabaseBookManager.shared.getBooks()
        bookTable.reloadData()
        
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        bookTable.reloadData()
    }*/
    
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
            return DatabaseBookManager.shared.books_unread.count
        }
        else{
            return DatabaseBookManager.shared.books_read.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! bookTableViewCell
        
        if viewSegment.selectedSegmentIndex == 0{
            print(indexPath.row)
            cell.book = DatabaseBookManager.shared.books_unread[indexPath.row]
            cell.setCell()
        }
        else{
            cell.book = DatabaseBookManager.shared.books_read[indexPath.row]
            cell.setCell()
        }
        
        return cell
    }
    
    
}
