//
//  RestaurantCell.swift
//  Yelp
//
//  Created by Matt Cline on 4/22/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import Foundation


class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessTitleLabel: UILabel!
    @IBOutlet weak var businessDistanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numReviewsLabel: UILabel!
    @IBOutlet weak var dollarSignsLabel: UILabel!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        businessImageView.layer.cornerRadius = 3
        businessImageView.clipsToBounds = true
        businessTitleLabel.preferredMaxLayoutWidth = businessTitleLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        businessTitleLabel.preferredMaxLayoutWidth = businessTitleLabel.frame.size.width        
    }
    
}
