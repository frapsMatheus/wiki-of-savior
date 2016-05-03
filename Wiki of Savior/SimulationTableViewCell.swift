//
//  SimulationTableViewCell.swift
//  Wiki of Savior
//
//  Created by Tiago Pigatto Lenza on 5/2/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit

class SimulationTableViewCell: UITableViewCell {

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
