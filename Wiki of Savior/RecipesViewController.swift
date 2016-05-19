//
//  RecipesViewController.swift
//  Wiki of Savior
//
//  Created by Tiago Pigatto Lenza on 5/18/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum SearchType {
        case Recipe
        case Item
    }
    
    //########## OUTLETS
    @IBOutlet var helperText: UILabel!
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var sw: UISwitch!
    @IBOutlet var textField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    //########## CLASS VARIABLES
    var searchType : SearchType!
    var searchObject : PFObject!
    var resultObjects : [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setupTableView()
        
    }
    
    //########## SETUP FUNCTIONS
    func configureView(){
        sw.layer.cornerRadius = 16.0
        sw.layer.borderColor = UIColor(colorLiteralRed: 0.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0).CGColor
        sw.on = false
        sw.addTarget(self, action: #selector(RecipesViewController.switchDidChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        helperText.text = "Enter the name of a recipe to find out its items"
        itemLabel.text = "Item"
        recipeLabel.text = "Recipe"
        recipeLabel.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        itemLabel.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        textField.placeholder = "Recipe"
        
        searchType = .Recipe
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerNib(UINib(nibName: "RecipeItemCell", bundle: nil), forCellReuseIdentifier: "RecipeItem")
        
    }
    
    //########## FUNCTIONS
    func switchDidChange(sender: UISwitch){
        
        if sender.on{
            helperText.text = "Enter the name of an item to find out if it belongs to any recipe"
            recipeLabel.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            itemLabel.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            textField.placeholder = "Item"
            searchType = .Item
            
        }else{
            helperText.text = "Enter the name of a recipe to find out its items"
            recipeLabel.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            itemLabel.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
            textField.placeholder = "Recipe"
            searchType = .Recipe
            
        }
        
        resultObjects = []
        self.tableView.reloadData()
        
    }
    //########## DELEGATE FUNCTIONS
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            
            if resultObjects != nil{
                return resultObjects.count
            }else{
                return 0
            }
            
        }else{
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeItem", forIndexPath: indexPath) as! RecipeItemTableViewCell
        cell.selectionStyle = .None
        
        if resultObjects != nil{
            if resultObjects != []{
                if searchType == .Recipe{
                    if indexPath.section == 0{
                        
                
                        cell.name.text = resultObjects[indexPath.row]["recipe"] as? String
                        cell.amount.text = ""
                        let imgFile = resultObjects[indexPath.row]["recipeImage"] as? PFFile
                        
                        imgFile?.getDataInBackgroundWithBlock({ (data : NSData?, error : NSError?) in
                            
                            if error == nil {
                                if let imageData = data {
                                    cell.img.image = UIImage(data: imageData)
                                }
                            }
                            
                        })
                    }else if indexPath.section == 1{
                        cell.name.text = resultObjects[indexPath.row]["item"] as? String
                        cell.amount.text = resultObjects[indexPath.row]["amount"] as? String
                        let imgFile = resultObjects[indexPath.row]["itemImage"] as? PFFile
                        
                        imgFile?.getDataInBackgroundWithBlock({ (data : NSData?, error : NSError?) in
                            
                            if error == nil {
                                if let imageData = data {
                                    cell.img.image = UIImage(data: imageData)
                                }
                            }
                            
                        })
                    }
                }else{
                    if indexPath.section == 0{
                        cell.name.text = resultObjects[indexPath.row]["item"] as? String
                        cell.amount.text = ""
                        let imgFile = resultObjects[indexPath.row]["itemImage"] as? PFFile
                        
                        imgFile?.getDataInBackgroundWithBlock({ (data : NSData?, error : NSError?) in
                            
                            if error == nil {
                                if let imageData = data {
                                    cell.img.image = UIImage(data: imageData)
                                }
                            }
                            
                        })
                    }else if indexPath.section == 1{
                        cell.name.text = resultObjects[indexPath.row]["recipe"] as? String
                        cell.amount.text = ""
                        let imgFile = resultObjects[indexPath.row]["recipeImage"] as? PFFile
                        
                        imgFile?.getDataInBackgroundWithBlock({ (data : NSData?, error : NSError?) in
                            
                            if error == nil {
                                if let imageData = data {
                                    cell.img.image = UIImage(data: imageData)
                                }
                            }
                            
                        })
                    }
                }
                
                
            }else{
                cell.name.text = ""
                cell.amount.text = ""
                cell.img.image = UIImage()
            }
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell")
        let label = cell?.viewWithTag(-1) as! UILabel
        
        if searchType == .Recipe{
            
            switch section{
            case 0:
                label.text = "Recipe"
            case 1:
                label.text = "Items"
            default:
                label.text = ""
            }
            
        }else{
            switch section{
            case 0:
                label.text = "Item"
            case 1:
                label.text = "Recipes"
            default:
                label.text = ""
            }
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 64.0
        
    }
    
    //########## OUTLET FUNCTIONS
    @IBAction func searchRecipeItem(sender: AnyObject) {
        
        
        if textField.text != ""{
            AdsManager.sharedInstance.showAd(self)
            MBProgressHUD.showHUDAddedTo(self.view, animated:true)
            performQuery((textField.text!).capitalizedString)
        }else{
            if searchType == .Recipe{
                let alert = UIAlertController(title: "", message: "Please enter the name of a recipe", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "", message: "Please enter the name of an item", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            
        }
        
    }
    
    func performQuery(item: String){
        var query : PFQuery!
        if searchType == .Recipe{
            query = PFQuery(className: "RecipeItem")
            query.whereKey("recipe", equalTo: item)
        }else{
            query = PFQuery(className: "RecipeItem")
            query.whereKey("item", equalTo: item)
        }
        
        query.findObjectsInBackgroundWithBlock { (objects : [PFObject]?, error : NSError?) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if objects != nil{
                if let objects = objects{
                    if objects != []{
                    self.resultObjects = objects
                    }else{
                        
                        if self.searchType == .Recipe{
                            let alert = UIAlertController(title: "", message: "Couldn't find any recipe named \(item)", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                        }else{
                            let alert = UIAlertController(title: "", message: "Couldn't find any item named \(item)", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
                
            }
            
            self.tableView.reloadData()
            
        }
    }
    
    
    //########## OVERRIDE FUNCTIONS
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
