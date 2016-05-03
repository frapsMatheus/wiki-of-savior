//
//  CardsXP.swift
//  Wiki of Savior
//
//  Created by Matheus Pedreira on 5/2/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit

class CardsXP: NSObject {

    var level:Int?
    var baseXP:Int?
    var classXP:Int?
    var minimumLevel:Int?
    
    init(dict:NSDictionary)
    {
        minimumLevel = (dict.objectForKey("MinimumLVL")  as! NSString).integerValue
        classXP = (dict.objectForKey("ClassXP")  as! NSString).integerValue
        baseXP = (dict.objectForKey("BaseXP")  as! NSString).integerValue
        level = (dict.objectForKey("Level")  as! NSString).integerValue
    }
    
}
