//
//  BaseLevel.swift
//  Wiki of Savior
//
//  Created by Matheus Pedreira on 5/1/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit

class BaseLevel: NSObject {

    var level:Int?
    var requiredXP:Int?
    var initialXP:Int?
    
    init(dict:NSDictionary)
    {
        requiredXP = (dict.objectForKey("RequiredXP") as! NSString).integerValue
        level = (dict.objectForKey("Level")  as! NSString).integerValue
        initialXP = (dict.objectForKey("BaseXP")  as! NSString).integerValue
    }
    
}
