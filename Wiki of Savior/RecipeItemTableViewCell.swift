//
//  RecipeItemTableViewCell.swift
//  Wiki of Savior
//
//  Created by Tiago Pigatto Lenza on 5/18/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit

class RecipeItemTableViewCell: UITableViewCell {

    
    @IBOutlet var img: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var amount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
