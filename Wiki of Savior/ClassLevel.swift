//
//  ClassLevel.swift
//  Wiki of Savior
//
//  Created by Matheus Pedreira on 5/2/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit

class ClassLevel: NSObject {

    var rank:Int?
    var level:Int?
    var requiredXP:Int?
    var initialXP:Int?
    
    init(dict:NSDictionary)
    {
        rank = (dict.objectForKey("Rank") as! NSString).integerValue
        requiredXP = (dict.objectForKey("RequiredXP") as! NSString).integerValue
        level = (dict.objectForKey("Level")  as! NSString).integerValue
        initialXP = (dict.objectForKey("BaseXP")  as! NSString).integerValue
    }
    
}
