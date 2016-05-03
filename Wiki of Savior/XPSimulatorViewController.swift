//
//  XPSimulatorViewController.swift
//  Wiki of Savior
//
//  Created by Matheus Pedreira on 5/1/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit
import KTCenterFlowLayout
import SwiftCSV

class XPSimulatorViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UITextFieldDelegate {

    var baseLevelField:UITextField?
    var baseXP:UITextField?
    var classRank:UITextField?
    var classLevel:UITextField?
    var classXP:UITextField?
    
    var currentTextField:UITextField?
    
    var baseXPArray:NSMutableDictionary?
    var classXPDict:NSMutableDictionary?
    var cardsDict:NSMutableDictionary?
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var didTap = false
    
    var cardsFieldArray:NSMutableDictionary = NSMutableDictionary.init(capacity: 12)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCSVs()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (!didTap) {
            let top = self.topLayoutGuide.length;
            let bottom = self.bottomLayoutGuide.length;
            let newInsets = UIEdgeInsetsMake(top, 0, bottom, 0)
            self.collectionView?.contentInset = newInsets
        }
    }

    func loadCSVs()
    {
        baseXPArray = NSMutableDictionary.init(capacity: 303)
        classXPDict = NSMutableDictionary.init(capacity: 7)
        cardsDict = NSMutableDictionary.init(capacity: 12)
        do {
//            Load base CSV
            let pathForXPtable = NSBundle.mainBundle().pathForResource("ExpTable", ofType: "csv")
            let baseLevelCSV = try CSV(name: pathForXPtable!, delimiter: ",", encoding: NSUTF8StringEncoding)
            for row in baseLevelCSV.rows {
                let baseLevel = BaseLevel.init(dict: row)
                baseXPArray?.setObject(baseLevel, forKey: baseLevel.level!)
            }
//            Load class CSV
            let pathForClassTable = NSBundle.mainBundle().pathForResource("ClassExpTable", ofType: "csv")
            let classLevelCSV = try CSV(name: pathForClassTable!, delimiter: ",", encoding: NSUTF8StringEncoding)
            var currentRank = 0
            var rankDict:NSMutableDictionary?
            for row in classLevelCSV.rows {
                let classLevel = ClassLevel.init(dict: row)
                if (currentRank != classLevel.rank) {
                    if (currentRank != 0) {
                        classXPDict?.setObject(rankDict!, forKey: currentRank)
                    }
                    rankDict = NSMutableDictionary.init(capacity: 15)
                    currentRank = classLevel.rank!
                }
                rankDict?.setObject(classLevel, forKey: classLevel.level!)
            }
            classXPDict?.setObject(rankDict!, forKey: currentRank)
//            Load card CSV
            let pathForCardsTable = NSBundle.mainBundle().pathForResource("CardsXP", ofType: "csv")
            let cardsCSV = try CSV(name: pathForCardsTable!, delimiter: ",", encoding: NSUTF8StringEncoding)
            for row in cardsCSV.rows {
                let card = CardsXP.init(dict: row)
                cardsDict?.setObject(card, forKey: card.level!)
            }
        } catch {
        
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 4;
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch (section) {
            case 0:
                return 2;
            case 1:
                return 3;
            case 2:
                return 12;
            default:
                return 1;
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell:UICollectionViewCell?
        switch indexPath.section{
        case 0,1:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("levelCell", forIndexPath:indexPath)
        case 2:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath:indexPath)
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("simulateCell", forIndexPath:indexPath)
        }
        let cellLabel = cell?.viewWithTag(-1) as? UILabel
        let textView = cell?.viewWithTag(-2) as? UITextField
        textView?.delegate = self
        switch indexPath.section {
            case 0:
                switch indexPath.row {
                    case 0:
                        baseLevelField = textView
                        baseLevelField?.placeholder = "1-301"
                        baseLevelField?.keyboardType = UIKeyboardType.NumberPad
                        cellLabel?.text = "Current Level"
                    default:
                        baseXP = textView
                        baseXP?.placeholder = "0.00-100.00"
                        baseXP?.keyboardType = UIKeyboardType.DecimalPad
                        cellLabel?.text = "Current %"
                }
            case 1:
                switch indexPath.row {
                    case 0:
                        classRank = textView
                        classRank?.placeholder = "1-7"
                        classRank?.keyboardType = UIKeyboardType.NumberPad
                        cellLabel?.text = "Current Rank"
                    case 1:
                        classLevel = textView
                        classLevel?.placeholder = "1-15"
                        classLevel?.keyboardType = UIKeyboardType.NumberPad
                        cellLabel?.text = "Current Level"
                    default:
                        classXP = textView
                        classXP?.placeholder = "0.00-100.00"
                        classXP?.keyboardType = UIKeyboardType.DecimalPad
                        cellLabel?.text = "Current %"
                }
            case 2:
                cellLabel?.text = "Lv. " + String(indexPath.row+1)
                cardsFieldArray.setObject(textView!, forKey: indexPath.row+1)
            default:
                break
        }
        return cell!;
    }
    
    @IBAction func simulate(sender: AnyObject) {
        
        guard ((baseLevelField?.text)! as NSString).intValue < 303 && ((baseLevelField?.text)! as NSString).intValue > 0 else {
            showError("Base level has to be between 1 and 302")
            return
        }
        guard ((baseXP?.text)! as NSString).floatValue <= 100.00 && ((baseXP?.text)! as NSString).floatValue > 0 else {
            showError("Base % has to be between 0.00% and 100%")
            return
        }
        let rank = ((classRank?.text)! as NSString).intValue
        guard rank > 0 && rank < 8 else {
            showError("Class rank to be between 1 and 7")
            return
        }
        let classLVL = ((classLevel?.text)! as NSString).intValue
        guard classLVL < 16 && classLVL>0 else {
            showError("Class level has to be between 1 and 15")
            return
        }
        let classXPPercentage = ((classXP?.text)! as NSString).floatValue
        guard classXPPercentage <= 100.00 && classXPPercentage > 0.00 else {
            showError("Class % has to be between 0.00% and 100%")
            return
        }
        let initialXP = getCurrentBaseXP()
        let initialClassXP = getCurrentClassXP()
        let cardsSum = sumCards()
        let finalXP = initialXP + (cardsSum.objectForKey("baseXP") as! Int)
        let finalClassXP = initialClassXP + (cardsSum.objectForKey("classXP") as! Int)
        
        let resultsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("XPResultsView") as! XPResultsScreenViewController
        
//        Base results
        resultsView.initialBaseLVL = ((baseLevelField?.text)! as NSString).integerValue
        resultsView.initialBasePercentage = ((baseXP?.text)! as NSString).floatValue
        resultsView.initialBaseXP = initialXP
        resultsView.cardsBaseXP = (cardsSum.objectForKey("baseXP") as! Int)
        
        let finalBase = searchLevelForBaseXP(finalXP)
        resultsView.finalBaseLVL = finalBase
        NSLog("Final level: " + String(finalBase))
        let finalBaseLevel = baseXPArray?.objectForKey(finalBase) as? BaseLevel
        resultsView.finalBaseXP = finalBaseLevel?.initialXP
        NSLog("Final base XP: " + String(finalBaseLevel?.initialXP))
        if (finalBase != 302) {
            let nextBaseLevel = baseXPArray?.objectForKey(finalBase+1) as? BaseLevel
            let finalBasePercentage = ((Float(finalXP)-Float(finalBaseLevel!.initialXP!))*100)/Float(nextBaseLevel!.requiredXP!)
            resultsView.finalBasePercentage = finalBasePercentage
            NSLog("Final base %: " + String(finalBasePercentage))
        }
        
//      Class Results
        resultsView.initialRank = Int(rank)
        resultsView.initialClassLVL = Int(classLVL)
        resultsView.initialClassPercentage = classXPPercentage
        resultsView.initialClassXP = initialClassXP
        resultsView.cardsClassXP = (cardsSum.objectForKey("baseXP") as! Int)
        
        let finalClass = searchLevelForClassXP(Int(rank), xp:finalClassXP)
        resultsView.finalClassRank = finalClass.rank
        resultsView.finalClassLVL = finalClass.level
        NSLog("Final class level: " + String(finalClass.level))
        NSLog("Final class rank: " + String(finalClass.rank))
        let rankDict = classXPDict?.objectForKey(finalClass.rank)
        let finalClassLevel = rankDict?.objectForKey(finalClass.level) as? ClassLevel
        resultsView.finalClassXP = finalClassLevel?.initialXP
        if (finalClass.level != 15) {
            
            let nextClassLevel = rankDict?.objectForKey(finalClass.level+1) as? ClassLevel
            let finalClassPercentage = (Float(finalClass.remainingXP)*100)/Float(nextClassLevel!.requiredXP!)
            resultsView.finalClassPercentage = finalClassPercentage
            NSLog("Final class % : " + String(finalClassPercentage))
        }
        self.navigationController?.pushViewController(resultsView, animated: true)
        NSLog("Done")
    }
    
    func showError(error:String)
    {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        didTap = true
        currentTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        didTap = false
    }
    
    @IBAction func didTapOutside(sender: AnyObject)
    {
        currentTextField?.resignFirstResponder()
    }
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:"headerCell", forIndexPath: indexPath)
        let title = cell.viewWithTag(-1) as? UILabel
        switch indexPath.section {
        case 0:
            title?.text = "Base Level"
        case 1:
            title?.text = "Class level"
        case 2:
            title?.text = "Cards"
        default:
            title?.text = ""
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = screenSize.width
        switch indexPath.section {
            case 0:
                return CGSizeMake((screenWidth/2)-10, 60);
            case 1:
                return CGSizeMake((screenWidth/3)-10, 60);
            case 2:
                return CGSizeMake(76, 60)
            default:
                return CGSizeMake(screenWidth,44)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0,1,2:
            return CGSizeMake(50,30)
        default:
            return CGSizeMake(0, 0)
        }
    }
    
    func getCurrentBaseXP() -> Int
    {
        let currentLevel = ((baseLevelField?.text!)! as NSString).integerValue
        let currentPercentage = ((baseXP?.text!)! as NSString).floatValue
        let level = searchForLevel(currentLevel);
        if (currentLevel == 302) {
            return level.initialXP!
        } else {
            let nextLevel = searchForLevel(currentLevel+1);
            let percentage = currentPercentage/100
            return (level.initialXP! + Int(Float(nextLevel.requiredXP!)*percentage))
        }
    }
    
    func getCurrentClassXP() -> Int
    {
        let currentRank = ((classRank?.text!)! as NSString).integerValue
        let currentLevel = ((classLevel?.text!)! as NSString).integerValue
        let currentPercentage = ((classXP?.text!)! as NSString).floatValue
        let level = searchForLevel(currentRank,currentLevel: currentLevel);
        if (currentLevel == 15) {
            return level.initialXP!
        } else {
            let nextLevel = searchForLevel(currentRank,currentLevel: currentLevel+1);
            let percentage = currentPercentage/100
            return (level.initialXP! + Int(Float(nextLevel.requiredXP!)*percentage))
        }
    }
    
    func searchForLevel(currentLevel: Int) -> BaseLevel
    {
        return (baseXPArray?.objectForKey(currentLevel))! as! BaseLevel
    }
    
    func searchForLevel(rank: Int, currentLevel: Int) -> ClassLevel
    {
        let rankDict = classXPDict?.objectForKey(rank) as? NSDictionary
        return (rankDict?.objectForKey(currentLevel))! as! ClassLevel
    }
    
    func sumCards() -> NSDictionary
    {
        var baseXP = 0
        var classXP = 0
        for i in 1...12 {
            let cardField = cardsFieldArray.objectForKey(i)
            let numberOfCards = ((cardField as! UITextField).text! as NSString).integerValue
            let card = cardsDict?.objectForKey(i) as! CardsXP
            baseXP += card.baseXP! * numberOfCards
            classXP += card.classXP! * numberOfCards
        }
        let dict = NSDictionary.init(objects: [baseXP,classXP], forKeys: ["baseXP","classXP"])
        return dict
    }
    
    func searchLevelForBaseXP(xp: Int) -> Int
    {
        for level in 1...302 {
            let baseLevel = baseXPArray?.objectForKey(level) as! BaseLevel
            if (baseLevel.initialXP > xp) {
                return level-1
            } else if (baseLevel.initialXP == xp) {
                return level
            }
        }
        return 302
    }
    
    func searchLevelForClassXP(rank: Int, xp: Int) -> (rank: Int,level:Int, remainingXP:Int)
    {
        var currentXP = xp
        for currentRank in rank...7 {
            let dict = classXPDict?.objectForKey(currentRank)
            for level in 1...15 {
                let classLevel = dict?.objectForKey(level) as! ClassLevel
                let initialXP = Int(classLevel.initialXP!)
                if (initialXP > currentXP) {
                    let oldClassLevel = dict?.objectForKey(level-1) as! ClassLevel
                    return (currentRank,level-1,currentXP-oldClassLevel.initialXP!)
                } else if (initialXP == currentXP) {
                    return (currentRank,level,0)
                }
            }
            let finalClassLevel = dict?.objectForKey(15) as! ClassLevel
            currentXP -= finalClassLevel.initialXP!
        }
        return (7,15,currentXP)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
