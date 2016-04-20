//
//  MapsTableViewController.swift
//  Wiki of Savior
//
//  Created by Matheus Pedreira on 4/20/16.
//  Copyright © 2016 Matrpedreira. All rights reserved.
//

import UIKit
import Parse
import JTSImageViewController
import MBProgressHUD

class MapsTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    var mapsDict = NSMutableDictionary();
    var levelsArray = NSMutableArray();
    
    var mapsSearchDict = NSMutableDictionary();
    var levelsSearchArray = NSMutableArray();
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    var searchController:UISearchController?
    
    var mapsOppened = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController!.searchResultsUpdater = self
        searchController!.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController!.searchBar
        downloadMapsData()
        navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        showAdd()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showAdd(){
        Chartboost.showInterstitial(CBLocationHomeScreen)
    }
    
    // MARK: - Table view data source

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if(!searchString!.isEmpty) {
            mapsSearchDict = NSMutableDictionary()
            levelsSearchArray = NSMutableArray()
            for level in levelsArray {
                let mapsArray = mapsDict.objectForKey(String(level)) as! NSArray
                let newMapsArray = NSMutableArray()
                for map in mapsArray {
                    if(verifyIfValid(map as! Map, string:searchString!)){
                        newMapsArray.addObject(map)
                    }
                }
                if (newMapsArray.count>0){
                    levelsSearchArray.addObject(level)
                    mapsSearchDict.setValue(newMapsArray, forKey:String(level))
                }
            }
        }else{
            self.levelsSearchArray = self.levelsArray
            self.mapsSearchDict = self.mapsDict
        }
        tableView.reloadData()
    }
    
    func verifyIfValid(map: Map, string:String)->Bool{
        if (map.name!.localizedCaseInsensitiveContainsString(string)) {
            return true
        }
        if (String(map.lvl!).localizedCaseInsensitiveContainsString(string)){
            return true
        }
        return false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mapsSearchDict.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let lvl = levelsSearchArray.objectAtIndex(section)
        let mapsArray = mapsSearchDict.objectForKey(String(lvl)) as! NSMutableArray
        return mapsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mapCell", forIndexPath: indexPath)
        let mapsArray = mapsSearchDict.objectForKey(String(levelsSearchArray.objectAtIndex(indexPath.section)))
        let map = mapsArray?.objectAtIndex(indexPath.row)
        
        let name = cell.viewWithTag(-1) as! UILabel;
        name.text = map?.name
        
        let type = cell.viewWithTag(-2) as! UILabel;
        type.text = map?.type
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("lvlCell")
        let lvl = headerCell!.viewWithTag(-1) as! UILabel;
        lvl.text = "Level " + String(levelsSearchArray.objectAtIndex(section))
        return headerCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mapsOppened += 1
        if(mapsOppened == 3){
            showAdd()
            mapsOppened = 0
        }
        let mapsArray = mapsSearchDict.objectForKey(String(levelsSearchArray.objectAtIndex(indexPath.section)))
        let map = mapsArray?.objectAtIndex(indexPath.row) as? Map
        map?.mapImage?.getDataInBackgroundWithBlock({ (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    let imageInfo = JTSImageInfo()
                    imageInfo.image = UIImage(data:imageData)
                    let controller = JTSImageViewController.init(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Scaled)
                    controller.showFromViewController(self, transition: JTSImageViewControllerTransition.FromOffscreen)
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
            }
        })
    }
    
    func downloadMapsData(){
        let query = PFQuery(className:"Maps")
        MBProgressHUD.showHUDAddedTo(self.view, animated:true)
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            MBProgressHUD.hideHUDForView(self.view, animated:true)
            for object in objects! {
                let map = Map(object: object)
                if !(self.levelsArray.containsObject(map.lvl!)) {
                    self.levelsArray.addObject(map.lvl!)
                    self.mapsDict.setObject(NSMutableArray(), forKey:String(map.lvl!))
                }
                let array = self.mapsDict.objectForKey(String(map.lvl!)) as? NSMutableArray
                array?.addObject(map)
            }
            self.levelsSearchArray = self.levelsArray
            self.mapsSearchDict = self.mapsDict
            self.tableView.reloadData()
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
