//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate : class {
    func filtersViewController(filterVC: FiltersViewController, filtersDidChange: Bool, filtersDictionary: [Int : Bool])
}

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var searchBar: UISearchBar!
    var businesses: [Business]!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Yelp!"
        self.navigationItem.titleView = self.searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            // refresh the ViewController (with new Geo data?)
            //println("\(notification)")
        }
        
        performSearch("ramen")
        
        reload()
    }
    
    func performSearch(queryString: String) {
        var limit = 0
        var offset = 0
        Business.searchWithTerm(queryString, sort: .Distance, categories: [], deals: false, limit: limit, offset: offset) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            for business in businesses {
                println(business.name!)
                println(business.address!)
            }
            self.reload()
        }
    }
    
    func clearResults() {
        self.businesses = []
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.clearResults()
        self.performSearch(searchBar.text)
        searchBar.resignFirstResponder()
        reload()
    }
    
    func reload() {
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        if let businesses = businesses {
            var business = businesses[indexPath.row]
            cell.businessTitleLabel?.text = "\(indexPath.row + 1). \(business.name!)"
            cell.businessImageView.setImageWithURL(business.imageURL)
            cell.businessDistanceLabel.text = business.distance
            cell.ratingImageView.setImageWithURL(business.ratingImageURL)
            cell.addressLabel.text = business.address
            cell.numReviewsLabel.text = "\(business.reviewCount!) Reviews"
            cell.dollarSignsLabel.text = "$$"
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

