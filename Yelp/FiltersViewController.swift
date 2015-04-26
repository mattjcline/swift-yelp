//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Matt Cline on 4/22/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterCellDelegate {

    private var filtersDictionary = [Int : Bool]()
    
    @IBOutlet weak var filtersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersTableView.dataSource = self
        filtersTableView.delegate = self
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as! FilterCell
        
        cell.delegate = self
        
        if let value = filtersDictionary[indexPath.row] {
            cell.filterSwitch.on = value
        } else {
            cell.filterSwitch.on = true
        }
        
        return cell
    }
    
    func filterCell(filterCell: FilterCell, value: Bool) {
        let indexPath = filtersTableView.indexPathForCell(filterCell)!
        filtersDictionary[indexPath.row] = value
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
