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
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSegment.backgroundColor = UIColor(red: 0.59, green: 0.92, blue: 0.82, alpha: 1)
        addButton.backgroundColor = UIColor(red: 0.59, green: 0.92, blue: 0.82, alpha: 1)
        addButton.layer.cornerRadius=25
        
        if DatabaseFilmManager.shared.films_watched.isEmpty && DatabaseFilmManager.shared.films_unwatched.isEmpty{
            DatabaseFilmManager.shared.getFilms(){
                self.filmTable.reloadData()
            }
        }

        filmTable.dataSource = self
        filmTable.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.filmTable.reloadData()
    }
    
    func filmCheck(){
        var count=0
        if viewSegment.selectedSegmentIndex == 0{
            for item in DatabaseFilmManager.shared.films_watched{
                if item.done == false{
                    DatabaseFilmManager.shared.films_unwatched.append(item)
                    DatabaseFilmManager.shared.films_watched.remove(at: count)
                }
                else{
                    count+=1
                }
            }
        }
        else{
            for item in DatabaseFilmManager.shared.films_unwatched{
                if item.done == true{
                    DatabaseFilmManager.shared.films_watched.append(item)
                    DatabaseFilmManager.shared.films_unwatched.remove(at: count)
                }
                else{
                    count+=1
                }
            }
        }
    }
    
    @IBAction func changeSegment(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.filmTable.alpha = CGFloat(0)
        }
        
        
        filmCheck()
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewSegment.selectedSegmentIndex == 0{
            DatabaseFilmManager.shared.chosenFilm = DatabaseFilmManager.shared.films_unwatched[indexPath.row]
        }
        else{
            DatabaseFilmManager.shared.chosenFilm = DatabaseFilmManager.shared.films_watched[indexPath.row]
        }
        
        performSegue(withIdentifier: "toSingleFilm", sender: self)
    }
}
