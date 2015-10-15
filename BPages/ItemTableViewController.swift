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

class ItemTableViewController: UITableViewController,UISearchBarDelegate {

    var itemType:MENU_TYPES = MENU_COUNTRY
    
    var delegate:ItemDelegate?
    
    var listofItems: [AnyObject]!

    var sortedKeys =  Dictionary<String, [AnyObject]>()

    var searchBar: UISearchBar!
    
    var searchActive: Bool!
    
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.shared().changeMenuButton();
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 40))
        searchBar.delegate = self
        tableView.tableHeaderView = searchBar
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let sortedNames = sortedKeys.keys.sort({ $0 < $1 })
        /*let oneKey = sortedNames[indexPath.section]
        
        let items = sortedKeys[oneKey] as Array!
        let item = items[indexPath.row]
        cell.textLabel?.text = item.objectForKey("name") as! String*/
        
        /*filtered = item.objectForKey("name").filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let nItem:NSNumber = NSNumber(unsignedInt: MENU_STATE.rawValue)
            print(AppDelegate.shared().currentSelectionDic)
            let item = AppDelegate.shared().currentSelectionDic.objectForKey(nItem) as! NSDictionary
            let query:String = String(format: "select * from cities where statecode = '%@'",item.objectForKey("iso") as! String)
            
            let cities = DBManager.sharedInstance().loadDataFromDB(query)
            for city in cities{
                let cname = (city[1] as! String).urlDecode() as String
                let curl = (city[2] as! String).urlDecode() as String
                let dicCity = ["name":cname,"url":curl]
                listofItems.append(dicCity)
            }
        }
        else if(itemType == MENU_SECTION)
        {
            let sections = DBManager.sharedInstance().loadDataFromDB("select * from section") as NSMutableArray
            listofItems = [NSMutableArray]()
            for section in sections{
                let sectionId = (section[1] as! String).urlDecode() as String
                let sectionName = (section[2] as! String).urlDecode() as String
                let dicSection = ["name":sectionName,"sectionId":sectionId]
                listofItems.append(dicSection)
            }
        }
        else if(itemType == MENU_CATEGORY)
        {
            let nItem:NSNumber = NSNumber(unsignedInt: MENU_SECTION.rawValue)
            let item = AppDelegate.shared().currentSelectionDic.objectForKey(nItem) as! NSDictionary
            let query:String = String(format: "select * from category where sectionId = '%@'",item.objectForKey("sectionId") as! String)
            let sections = DBManager.sharedInstance().loadDataFromDB(query) as NSMutableArray
            listofItems = [NSMutableArray]()
            for section in sections{
                let catId = (section[1] as! String).urlDecode() as String
                let catName = (section[2] as! String).urlDecode() as String
                let dicSection = ["name":catName,"catId":catId]
                listofItems.append(dicSection)
            }
        }
        else if(itemType == MENU_SUBMIT)
        {
            let nSectionItem:NSNumber = NSNumber(unsignedInt: MENU_SECTION.rawValue)
            let sectionitem = AppDelegate.shared().currentSelectionDic.objectForKey(nSectionItem) as! NSDictionary
            
            let ncatItem:NSNumber = NSNumber(unsignedInt: MENU_CATEGORY.rawValue)
            let catitem = AppDelegate.shared().currentSelectionDic.objectForKey(ncatItem) as! NSDictionary
            
            let query:String = String(format: "select * from ad where sectionId = '%@' and catId = '%@'",sectionitem.objectForKey("sectionId") as! String,catitem.objectForKey("catId") as! String)
            
            let ads = DBManager.sharedInstance().loadDataFromDB(query) as NSMutableArray
            listofItems = [NSMutableArray]()
            for ad in ads{
                let adTitle = (ad[8] as! String).urlDecode() as String
                let adId = (ad[3] as! String).urlDecode() as String
                let adImages = (ad[4] as! String).urlDecode() as String
                let data = adImages.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
                do{
                let arrayOfImages: AnyObject! = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    let dicOneAd = ["title":adTitle,"adId":adId,"images":arrayOfImages]
                    listofItems.append(dicOneAd)
                }
                catch _ as NSError{
                    
                }
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
        //if(searchActive == true){
        //    cell.textLabel?.text = filtered[indexPath.row]
        //} else {
            let sortedNames = sortedKeys.keys.sort({ $0 < $1 })
            let oneKey = sortedNames[indexPath.section]
            
            let items = sortedKeys[oneKey] as Array!
            let item = items[indexPath.row]
            cell.textLabel?.text = item.objectForKey("name") as! String
        //}
        
        
        
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
