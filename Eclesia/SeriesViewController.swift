//
//  PlayersViewController.swift
//  Eclesia
//
//  Created by Selase Kwawu on 26/04/2017.
//  Copyright © 2017 Selase Kwawu. All rights reserved.
//

import UIKit

class SeriesViewController: UITableViewController {
    

    let sermon = Sermon()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        
        sermon.parseData(route: "series") {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sermon.fetchedSermon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeriesCell", for: indexPath) as! SeriesCell

        let sermons = sermon.fetchedSermon[indexPath.row] as SermonData
        
        
        cell.series = sermons
        cell.accessoryType = .disclosureIndicator

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sermons = sermon.fetchedSermon[indexPath.row] as SermonData
   
        performSegue(withIdentifier: "toSermon", sender: sermons)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSermon" {
            
            let nav = segue.destination as! UINavigationController
            let sermonVC = nav.topViewController as! SermonViewController
            
            sermonVC.series = (sender as! SermonData!)
        }
        
    }
    
    func imageForRating(rating:Int) -> UIImage? {
        let imageName = "\(rating)Stars"
        return UIImage(named: imageName)
    }
    

    @IBAction func cancelSermonViewController(segue:UIStoryboardSegue) {
        
    }
 

}
