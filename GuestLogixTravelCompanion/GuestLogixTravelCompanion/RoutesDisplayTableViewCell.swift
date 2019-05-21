//
//  RoutesDisplayTableViewCell.swift
//  GuestLogixTravelCompanion
//
//  Created by Balakumaran Srirangaswamy on 5/17/19.
//  Copyright © 2019 Bala. All rights reserved.
//

import UIKit

class RoutesDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var airlinesLabel: UILabel!
    @IBOutlet weak var numberOfStopsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
