//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

let yelpConsumerKey = "bk5cp99G7OtbtGOJvrzf5Q"
let yelpConsumerSecret = "onEbMImrgTPCLqXmETow1LZIGjE"
let yelpToken = "2-_l944aQx8ZHbJ6g5yhaUpiJa-sGoAQ"
let yelpTokenSecret = "V7Y5evlAKknjcvnA1PJiEtKqo5E"

enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    class var sharedInstance : YelpClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : YelpClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        }
        return Static.instance!
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(term, sort: nil, categories: nil, deals: nil, limit: 0, offset: 0, completion: completion)
    }
    
    func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, limit: Int, offset: Int, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        
        // Default the location to San Francisco
        var parameters: [String : AnyObject] = ["term": term, "ll": "37.785771,-122.406165"]
        
        if sort != nil {
            parameters["sort"] = sort!.rawValue
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = ",".join(categories!)
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals!
        }
        
        println(parameters)
        
        return self.GET("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var dictionaries = response["businesses"] as? [NSDictionary]
            if dictionaries != nil {
                completion(Business.businesses(array: dictionaries!), nil)
            }
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(nil, error)
        })
    }
}

