//
//  Map.swift
//  Wiki of Savior
//
//  Created by Matheus Pedreira on 4/20/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit
import Parse
class Map: NSObject {

    var name:String?
    var lvl:Int?
    var mapImage:PFFile?
    var type:String?
    
    init(object:PFObject){
        name = object["Name"] as? String
        type = object["Type"] as? String
        lvl = object["Lv"] as? Int
        mapImage = object["Image"] as? PFFile
    }
    
    
}
