//
//  AdCollectionViewController.swift
//  BPages
//
//  Created by Gal Blank on 10/13/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AdCollectionViewController: UICollectionViewController {

    var itemType:MENU_TYPES = MENU_COUNTRY
    
    var delegate:ItemDelegate?
    
    var listofItems: [AnyObject]!
    
    var sortedKeys =  Dictionary<String, [AnyObject]>()

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return listofItems.count
    }
    
    /*func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 80, height: 100)
    }*/

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
    
        // Configure the cell
        let item = listofItems[indexPath.row] as! NSDictionary
        let imagesarray:NSMutableArray = item.objectForKey("images") as! NSMutableArray
        if(imagesarray.count > 0){
            let imageurl:String = imagesarray[0] as! String
            let url = NSURL(string: imageurl)
            cell.imageView.setImageWithURL(url!, placeholderImage: UIImage(contentsOfFile: "profile"))
        }
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}