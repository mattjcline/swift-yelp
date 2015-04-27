//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    var searchBar: UISearchBar!
    var businesses: [Business]!
    let limit = 20
    var offset = 0
    var previousQueryString = ""
    
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
        
        performSearch("burgers")
    }
    
    func performSearch(queryString: String) {
        Business.searchWithTerm(queryString, sort: .Distance, categories: [], deals: false, limit: self.limit, offset: self.offset) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            for business in businesses {
                println(business.name!)
                println(business.address!)
            }
            if queryString == self.previousQueryString {
                self.offset = self.offset + self.limit
            } else {
                self.previousQueryString = queryString
                self.resetResultsOffset()
            }
            self.reload()
        }
    }
    
    func resetResultsOffset() {
        self.offset = 0
    }
    
    func clearResults() {
        self.businesses = []
        resetResultsOffset()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        var categories = filters["categories"] as? [String]
        
        Business.searchWithTerm("burgers", sort: nil, categories: categories, deals: nil, limit: 20, offset: 0) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
    
}

