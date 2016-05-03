//
//  Simulation.swift
//  Wiki of Savior
//
//  Created by Tiago Pigatto Lenza on 4/28/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import Foundation


class Simulation {
    
    var str : Float!
    var con : Float!
    var int : Float!
    var spr : Float!
    var dex : Float!
    var lvl : Float!
    var classType : String!
    
    var classHPMultiplier : Float {
        get{
            switch classType {
            case "Archer":
                return 1.4
            case "Swordsman":
                return 3.3
            case "Cleric":
                return 1.5
            case "Wizard":
                return 1.1
            default:
                return 1
            }
        }
    }
    
    var classSPMultiplier : Float {
        get{
            switch classType {
            case "Archer":
                return 0.9
            case "Swordsman":
                return 0.8
            case "Cleric":
                return 1.2
            case "Wizard":
                return 1.2
            default:
                return 1
            }
        }
    }
    
    init (str : Float, con : Float, int : Float, spr:Float, dex : Float, lvl : Float, classType : String){
        
        self.str = str
        self.con = con
        self.int = int
        self.spr = spr
        self.dex = dex
        self.lvl = lvl
        self.classType = classType
        
    }
    
    func getSimulationArray() -> [Int] {
        var array : [Int] = []
        
        
        array.append(hp)
        array.append(sp)
        array.append(hpRecovery)
        array.append(spRecovery)
        array.append(physicalAttack)
        array.append(magicAttack)
        array.append(aoeAttackRatio)
        array.append(accuracy)
        array.append(magicAplification)
        array.append(blockPenetration)
        array.append(criticalAttack)
        array.append(criticalRate)
        array.append(physicalDefense)
        array.append(magicDefense)
        array.append(aoeDefenseRatio)
        array.append(evasion)
        array.append(block)
        array.append(criticalResistance)
        array.append(stamina)
        array.append(weightLimit)
        
        return array
        
    }
    
    var hp : Int{
        get{
            let lvlPart = (lvl - 1) * 17
            
            return Int((classHPMultiplier * lvlPart) + con * 85)
            
        }
    }
    
    var sp : Int{
        get{
            if classType != "Cleric"{
                
                let lvlPart = (lvl - 1) * 6.7
                
                return Int((classSPMultiplier * lvlPart) + (spr * 13))
            }else{
                let lvlPart = Float(lvl - 1) * 6.7
                
                let spPart =  (classSPMultiplier * lvlPart) + (spr * 13)
                
                return Int(spPart + (lvl * 1.675))
            }
            
        }
    }
    
    var hpRecovery : Int {
        get{
            switch classType {
            case "Archer":
                return Int(0.7*lvl + con)
            case "Swordsman":
                return Int(1.65*lvl + con)
            case "Cleric":
                return Int(0.75*lvl + con)
            case "Wizard":
                return Int(0.55*lvl + con)
            default:
                return 0
            }
        }
    }
    
    var spRecovery : Int{
        get{
            switch classType {
            case "Archer":
                return Int(0.45*lvl + spr)
            case "Swordsman":
                return Int(0.4*lvl + spr)
            case "Cleric":
                return Int(0.85*lvl + spr)
            case "Wizard":
                return Int(0.6*lvl + spr)
            default:
                return 0
            }
        }
    }
    
    var physicalAttack : Int {
        get{
            return Int(lvl + str)
        }
    }
    
    var magicAttack : Int {
        get{
            return Int(lvl + int)
        }
    }
    
    
    var aoeAttackRatio : Int {
        get{
            switch classType {
            case "Archer":
                return 0
            case "Swordsman":
                return 4
            case "Cleric":
                return 3
            case "Wizard":
                return 3
            default:
                return 0
            }
        }
    }
    
    
    var accuracy : Int{
        get {
            if classType != "Archer" {
                return Int(lvl + dex)
            }else{
                return Int((lvl + dex) + ((lvl + 4)/4))
            }
        }
    }
    
    var magicAplification : Int {
        get{
            return 0
        }
    }
    
    var blockPenetration : Int {
        get {
            return Int((lvl * 0.5) + spr)
        }
    }
    
    var criticalAttack : Int {
        get {
            return Int(str)
        }
    }
    
    var criticalRate : Int {
        get {
            if classType != "Archer" {
                return Int(dex)
            }else{
                return Int(dex + (lvl/5))
            }
        }
    }
    
    var physicalDefense : Int {
        get {
            if classType != "Swordsman" {
                return Int(lvl/2)
            }else{
                return Int((lvl/2) + (lvl/4))
            }
        }
    }
    
    
    var magicDefense : Int {
        get{
            if classType != "Wizard" {
                return Int((lvl/2) + (spr/5))
            }else{
                return Int((lvl/2) + (spr/5) + (lvl/4))
            }
        }
    }
    
    var aoeDefenseRatio : Int {
        get {
            return 1
        }
    }
    
    var evasion : Int {
        get {
            if classType != "Archer" {
                return Int(lvl + dex)
            }else{
                return Int((lvl + dex) + (lvl/8))
            }
        }
    }
    
    var block : Int {
        get {
            return 0
        }
    }
    
    var criticalResistance : Int {
        get {
            return Int(con)
        }
    }
    
    var stamina : Int {
        get {
            return 25
        }
    }
    
    var weightLimit : Int {
        get {
            return Int(5000 + (con * 5) + (str*5))
        }
    }
    
    
    
    
    
    
    
}