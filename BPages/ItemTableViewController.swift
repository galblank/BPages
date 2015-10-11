//
//  ItemTableViewController.swift
//  BPages
//
//  Created by Gal Blank on 10/5/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

import UIKit

@objc protocol ItemDelegate{
    func selectedItem(item:[String:AnyObject],menuItem:MENU_TYPES)
}

class ItemTableViewController: UITableViewController {

    var itemType:MENU_TYPES = MENU_COUNTRY
    
    var delegate:ItemDelegate?
    
    var listofItems: [AnyObject]!

    var sortedKeys =  Dictionary<String, [AnyObject]>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.shared().changeMenuButton();
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        
    }
    
    func updateItemsForMenuType()
    {
        if(listofItems != nil){
            listofItems.removeAll()
        }
        
        if(sortedKeys.count > 0){
            sortedKeys.removeAll()
        }
        
        if(itemType == MENU_STATE){
            let states = DBManager.sharedInstance().loadDataFromDB("select * from states") as NSMutableArray
            listofItems = [NSMutableArray]()
            for oneState in states{
                let  mutabDic = ["name":oneState.objectAtIndex(1),"iso":oneState.objectAtIndex(2)]
                listofItems.append(mutabDic)
            }
        }
        else if(itemType == MENU_COUNTRY){
            guard let path = NSBundle.mainBundle().pathForResource("countries", ofType: "txt") else {
                return
            }
            
            do {
                let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
                let jsonData: NSData = content.dataUsingEncoding(NSUTF8StringEncoding)!/* get your json data */
                
                listofItems = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! [AnyObject]
                
                
            } catch _ as NSError {
                
            }
        }
        else if(itemType == MENU_CITY){
            listofItems = [NSMutableArray]()
            let query:String = String(format: "select * from cities where statecode = '%@'",AppDelegate.shared().currentSelectionDic.objectForKey("state") as! String)
            
            let cities = DBManager.sharedInstance().loadDataFromDB(query)
            for city in cities{
                let cname = (city[1] as! String).urlDecode() as String
                let curl = (city[2] as! String).urlDecode() as String
                let dicCity = ["name":cname,"url":curl]
                listofItems.append(dicCity)
            }
        }
        
        for item:AnyObject in listofItems{
            let cName:String = item.objectForKey("name") as! String
            let firstLetter:String = cName[0]
            
            var countries:[AnyObject] = [AnyObject]()
            if(sortedKeys[firstLetter] != nil){
                countries = sortedKeys[firstLetter]!
            }
            countries.append(item)
            sortedKeys[firstLetter] = countries
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sortedKeys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sortedNames = sortedKeys.keys.sort({ $0 < $1 })
        let oneKey = sortedNames[section]
        
        let items = sortedKeys[oneKey] as AnyObject?
        return items!.count
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        let sortedNames = sortedKeys.keys.sort({ $0 < $1 })
        return sortedNames
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let sortedNames = sortedKeys.keys.sort({ $0 < $1 })
        let oneKey = sortedNames[indexPath.section]
        let items = sortedKeys[oneKey] as Array!
        let item = items[indexPath.row]
        delegate?.selectedItem(item as! [String : AnyObject], menuItem: itemType)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        let sortedNames = sortedKeys.keys.sort({ $0 < $1 })
        let oneKey = sortedNames[indexPath.section]
        
        let items = sortedKeys[oneKey] as Array!
        let item = items[indexPath.row]
        cell.textLabel?.text = item.objectForKey("name") as! String
        
        return cell
    }
    

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
