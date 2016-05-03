//
//  StatsCalculatorViewController.swift
//  Wiki of Savior
//
//  Created by Tiago Pigatto Lenza on 5/2/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit
import Crashlytics

class StatsCalculatorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //########## OUTLETS
    @IBOutlet var tableView: UITableView!
    @IBOutlet var strTextField: UITextField!
    @IBOutlet var conTextField: UITextField!
    @IBOutlet var sprTextField: UITextField!
    @IBOutlet var dexTextField: UITextField!
    @IBOutlet var intTextField: UITextField!
    @IBOutlet var lvlTextField: UITextField!
    @IBOutlet var classTextField: UITextField!
    
    
    var calculateCount = 0
    
    //########## VARIABLES
    var picker : UIPickerView!
    var classes : [String] = ["Archer", "Cleric", "Swordsman", "Wizard"]
    var simulationVariables : [Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        classTextField.inputView = picker
        
        setupTableView()
    }
    
    func showAdd(){
        Chartboost.showInterstitial(CBLocationHomeScreen)
    }
    
    //########## SETUP FUNCTIONS
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "SimulationCell", bundle: nil), forCellReuseIdentifier: "simulationCell")
        
    }
    
    func getNameForIndexPath(indexPath : NSIndexPath) -> String {
        switch indexPath.row {
        case 0:
            return "HP"
        case 1:
            return "SP"
        case 2:
            return "HP Recovery"
        case 3:
            return "SP Recovery"
        case 4:
            return "Physical Attack"
        case 5:
            return "Magic Attack"
        case 6:
            return "AOE Attack Ratio"
        case 7:
            return "Accuracy"
        case 8:
            return "Magic Amplification"
        case 9:
            return "Block Penetration"
        case 10:
            return "Critical Attack"
        case 11:
            return "Critical Rate"
        case 12:
            return "Physical Defense"
        case 13:
            return "Magic Defense"
        case 14:
            return "AOE Defense Ratio"
        case 15:
            return "Evasion"
        case 16:
            return "Block"
        case 17:
            return "Critical Resistance"
        case 18:
            return "Stamina"
        case 19:
            return "Weight Limit"
        default:
            return ""
        }
    }
    
    //########## PICKERVIEW DELEGATE FUNCTIONS
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return classes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return classes[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        classTextField.text = classes[row]
        
        self.view.endEditing(true)
        
    }
    
    
    //########## TABLEVIEW DELEGATE FUNCTIONS
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if simulationVariables != nil{
            return simulationVariables.count
        }else{
            return 0
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("simulationCell", forIndexPath: indexPath) as! SimulationTableViewCell
        cell.selectionStyle = .None
        
        cell.titleLabel.text = getNameForIndexPath(indexPath)
        cell.valueLabel.text = String(simulationVariables![indexPath.row])
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    //########## OUTLET FUNCTIONS
    @IBAction func calculate(sender: AnyObject) {
        
        
        if strTextField.text != "" && conTextField.text != "" && intTextField.text != "" && sprTextField.text != "" && dexTextField.text != "" && lvlTextField.text != "" && classTextField.text != ""{
            calculateCount += 1
            
            if (calculateCount==3) {
                showAdd()
                calculateCount = 0
            }
            
            let simulation = Simulation(str: Float(strTextField.text!)!, con: Float(conTextField.text!)!, int: Float(intTextField.text!)!, spr: Float(sprTextField.text!)!, dex: Float(dexTextField.text!)!, lvl: Float(lvlTextField.text!)!, classType: classTextField.text!)
            
            simulationVariables = simulation.getSimulationArray()
            
            tableView.reloadData()
        }else{
            
            let alert = UIAlertController(title: "", message: "Please fill all the fields.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    //########## OVERRIDE FUNCTIONS
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
