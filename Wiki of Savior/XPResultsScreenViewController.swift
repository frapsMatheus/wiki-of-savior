//
//  XPResultsScreenViewController.swift
//  Wiki of Savior
//
//  Created by Matheus Pedreira on 5/3/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit

class XPResultsScreenViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
//  Base info
    var initialBaseLVL:Int?
    var finalBaseLVL:Int?
    var initialBaseXP:Int?
    var finalBaseXP:Int?
    var initialBasePercentage:Float?
    var finalBasePercentage:Float?
    
//  Class info
    var initialRank:Int?
    var initialClassLVL:Int?
    var initialClassXP:Int?
    var initialClassPercentage:Float?
    var finalClassRank:Int?
    var finalClassLVL:Int?
    var finalClassXP:Int?
    var finalClassPercentage:Float?
    
    let initialColor = UIColor.init(red: 102/255, green: 153/255, blue: 153/255, alpha: 1.0)
    let resultColor = UIColor.init(red: 0/255, green: 51/255, blue: 51/255, alpha: 1.0)
    let dividerColor = UIColor.init(red:  153/255, green: 102/255, blue: 51/255, alpha: 1.0)
    let stringArray = NSMutableArray.init(capacity: 30)
    
//  Card info
    var cardsBaseXP:Int?
    var cardsClassXP:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateBaseInfo()
        stringArray.addObject(NSAttributedString.init(string: "\n"))
        generateClassInfo()
        
//      Final string
        let finalString = NSMutableAttributedString.init(string: "",
                                                         attributes: [NSFontAttributeName : UIFont.systemFontOfSize(30)])
        for string in stringArray {
            finalString.appendAttributedString(string as! NSAttributedString)
            finalString.appendAttributedString(NSAttributedString.init(string: "\n"))
        }
        textView.attributedText = finalString
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        AdsManager.sharedInstance.showAd(self)
    }
    
    func generateBaseInfo()
    {
        stringArray.addObject(NSAttributedString.init(string: "Base Information"))
        stringArray.addObject(NSAttributedString.init(string:"============================================",
            attributes:[NSForegroundColorAttributeName: dividerColor]))
        
        let lvlString = NSMutableAttributedString.init(string: "Initial level: ")
        let lvl = NSAttributedString.init(string: String(initialBaseLVL!),
                                          attributes: [NSForegroundColorAttributeName: initialColor])
        lvlString.appendAttributedString(lvl)
        stringArray.addObject(lvlString)
        
        let baseXPString = NSMutableAttributedString.init(string: "Initial total XP is: ")
        let baseXP = NSAttributedString.init(string: String(initialBaseXP!),
                                             attributes: [NSForegroundColorAttributeName: initialColor])
        baseXPString.appendAttributedString(baseXP)
        stringArray.addObject(baseXPString)
        
        let basePercentageString = NSMutableAttributedString.init(string: "The initial extra percentage is: ")
        let babasePercentage = NSAttributedString.init(string: (NSString(format: "%.2f", initialBasePercentage!) as String) + "%",
                                                       attributes: [NSForegroundColorAttributeName: initialColor])
        basePercentageString.appendAttributedString(babasePercentage)
        stringArray.addObject(basePercentageString)
        
        let baseCardXPString = NSMutableAttributedString.init(string: "The total XP gained from cards is: ")
        let baseCardXP = NSAttributedString.init(string: String(cardsBaseXP!),
                                                 attributes: [NSForegroundColorAttributeName: resultColor])
        baseCardXPString.appendAttributedString(baseCardXP)
        stringArray.addObject(baseCardXPString)
        
        let finalBaseLVLString = NSMutableAttributedString.init(string: "\nThe final level is: ")
        let finalLVL = NSAttributedString.init(string: String(finalBaseLVL!),
                                               attributes: [NSForegroundColorAttributeName: resultColor])
        finalBaseLVLString.appendAttributedString(finalLVL)
        stringArray.addObject(finalBaseLVLString)
        
        let totalBaseXPString = NSMutableAttributedString.init(string: "The final total XP is: ")
        let totalBaseXP = NSAttributedString.init(string: String(finalBaseXP!),
                                                  attributes: [NSForegroundColorAttributeName: resultColor])
        totalBaseXPString.appendAttributedString(totalBaseXP)
        stringArray.addObject(totalBaseXPString)
        
        if ((finalBasePercentage) != nil) {
            let finalXPPercentageString = NSMutableAttributedString.init(string: "The final extra percentage is: ")
            let finalPercetage = NSAttributedString.init(string: (NSString(format: "%.2f", finalBasePercentage!) as String) + "%",
                                                         attributes: [NSForegroundColorAttributeName: resultColor])
            finalXPPercentageString.appendAttributedString(finalPercetage)
            stringArray.addObject(finalXPPercentageString)
        }

    }
    
    func generateClassInfo()
    {
        stringArray.addObject(NSAttributedString.init(string: "Class Information"))
        stringArray.addObject(NSAttributedString.init(string:"============================================",
            attributes:[NSForegroundColorAttributeName: dividerColor]))
    
        let rankString = NSMutableAttributedString.init(string: "Initial rank: ")
        let rank = NSAttributedString.init(string: String(initialRank!),
                                          attributes: [NSForegroundColorAttributeName: initialColor])
        rankString.appendAttributedString(rank)
        stringArray.addObject(rankString)
        
        let lvlString = NSMutableAttributedString.init(string: "Initial level: ")
        let lvl = NSAttributedString.init(string: String(initialClassLVL!),
                                          attributes: [NSForegroundColorAttributeName: initialColor])
        lvlString.appendAttributedString(lvl)
        stringArray.addObject(lvlString)
        
        let classXPString = NSMutableAttributedString.init(string: "Initial rank XP is: ")
        let classXP = NSAttributedString.init(string: String(initialClassXP!),
                                             attributes: [NSForegroundColorAttributeName: initialColor])
        classXPString.appendAttributedString(classXP)
        stringArray.addObject(classXPString)
        
        let classPercentageString = NSMutableAttributedString.init(string: "The initial extra percentage is: ")
        let classPercentage = NSAttributedString.init(string: (NSString(format: "%.2f", initialClassPercentage!) as String) + "%",
                                                       attributes: [NSForegroundColorAttributeName: initialColor])
        classPercentageString.appendAttributedString(classPercentage)
        stringArray.addObject(classPercentageString)
        
        let baseCardXPString = NSMutableAttributedString.init(string: "The total XP gained from cards is: ")
        let baseCardXP = NSAttributedString.init(string: String(cardsClassXP!),
                                                 attributes: [NSForegroundColorAttributeName: resultColor])
        baseCardXPString.appendAttributedString(baseCardXP)
        stringArray.addObject(baseCardXPString)
        
        let finalRankString = NSMutableAttributedString.init(string: "\nFinal rank: ")
        let finalRank = NSAttributedString.init(string: String(finalClassRank!),
                                           attributes: [NSForegroundColorAttributeName: resultColor])
        finalRankString.appendAttributedString(finalRank)
        stringArray.addObject(finalRankString)
        
        let finalLvlString = NSMutableAttributedString.init(string: "Final level: ")
        let finalLvl = NSAttributedString.init(string: String(finalClassLVL!),
                                          attributes: [NSForegroundColorAttributeName: resultColor])
        finalLvlString.appendAttributedString(finalLvl)
        stringArray.addObject(finalLvlString)
        
        let finalClassXPString = NSMutableAttributedString.init(string: "Final rank XP is: ")
        let finalXP = NSAttributedString.init(string: String(finalClassXP!),
                                              attributes: [NSForegroundColorAttributeName: resultColor])
        finalClassXPString.appendAttributedString(finalXP)
        stringArray.addObject(finalClassXPString)
        
        if ((finalClassPercentage) != nil) {
            let finalClassPercentageString = NSMutableAttributedString.init(string: "The final extra percentage is: ")
            let finalPercentage = NSAttributedString.init(string: (NSString(format: "%.2f", finalClassPercentage!) as String) + "%",
                                                          attributes: [NSForegroundColorAttributeName: resultColor])
            finalClassPercentageString.appendAttributedString(finalPercentage)
            stringArray.addObject(finalClassPercentageString)
        }
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
