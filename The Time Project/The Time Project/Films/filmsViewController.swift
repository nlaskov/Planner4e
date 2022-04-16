//
//  filmsViewController.swift
//  The Time Project
//
//  Created by Nikola Laskov on 17.04.22.
//

import Foundation
import UIKit

class filmsViewController: UIViewController{
    
    @IBOutlet var viewSegment: UISegmentedControl!
    @IBOutlet var filmTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filmTable.dataSource = self
        filmTable.delegate = self
        
        if DatabaseFilmManager.shared.films_watched.isEmpty{
            DatabaseFilmManager.shared.getFilms()
        }
        filmTable.reloadData()

    }
    
    @IBAction func changeSegment(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.filmTable.alpha = CGFloat(0)
        }
        
        filmTable.reloadData()
        
        UIView.animate(withDuration: 0.5) {
            self.filmTable.alpha = CGFloat(1)
        }
    }
}

extension filmsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewSegment.selectedSegmentIndex == 0{
            return DatabaseFilmManager.shared.films_unwatched.count
        }
        else{
            return DatabaseFilmManager.shared.films_watched.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as! filmTableViewCell
        
        if viewSegment.selectedSegmentIndex == 0{
            print(indexPath.row)
            cell.film = DatabaseFilmManager.shared.films_unwatched[indexPath.row]
            cell.setCell()
        }
        else{
            cell.film = DatabaseFilmManager.shared.films_watched[indexPath.row]
            cell.setCell()
        }
        
        return cell
    }
    
    
}
