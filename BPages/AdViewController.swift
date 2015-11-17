//
//  AdViewController.swift
//  BPages
//
//  Created by Gal Blank on 10/14/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

import UIKit

class AdViewController: UIViewController {

    var adDic:NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("%@", self.adDic)
        let query:String = String(format: "select * from ad where adId = %@",sectionitem.objectForKey("sectionId") as! String,catitem.objectForKey("catId") as! String)
        
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
        
            /*[[CommManager sharedInstance] getAPIBlockWithPrefix:ROOT_API andApi:api andParams:nil completion:^(NSMutableDictionary * result) {
            NSXMLParser * parser = [result objectForKeyedSubscript:@"result"];
            NSError * error;
            NSMutableDictionary * document = [[XmlHandler dictionaryNSXmlParseObject:parser error:error] mutableCopy];
            NSMutableArray * cities = [[[document objectForKeyedSubscript:@"rss"] objectForKey:@"channel"] objectForKey:@"item"];
            for(NSMutableDictionary * oneCity in cities){
            NSString * name = [[[oneCity objectForKeyedSubscript:@"bp:City"] objectForKey:@"bp:City"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * url = [[[oneCity objectForKeyedSubscript:@"bp:BackpageURL"] objectForKey:@"bp:BackpageURL"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * country = [[[oneCity objectForKeyedSubscript:@"bp:Country"] objectForKey:@"bp:Country"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * countrycode = [[[oneCity objectForKeyedSubscript:@"bp:CountryCode"] objectForKey:@"bp:CountryCode"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * bpid = [[[oneCity objectForKeyedSubscript:@"bp:Id"] objectForKey:@"bp:Id"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * latitude = [[[oneCity objectForKeyedSubscript:@"bp:Latitude"] objectForKey:@"bp:Latitude"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * longitude = [[[oneCity objectForKeyedSubscript:@"bp:Longitude"] objectForKey:@"bp:Longitude"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * parent = [[[oneCity objectForKeyedSubscript:@"bp:Parent"] objectForKey:@"bp:Parent"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * postingurl = [[[oneCity objectForKeyedSubscript:@"bp:PostingURL"] objectForKey:@"bp:PostingURL"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * statecode = [[[oneCity objectForKeyedSubscript:@"bp:State"] objectForKey:@"bp:State"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * statename = [[[oneCity objectForKeyedSubscript:@"bp:StateFull"] objectForKey:@"bp:StateFull"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString * query = [NSString stringWithFormat:@"select * from cities where url = '%@'",[url urlEncode]];
            NSArray * city = [[DBManager sharedInstance] loadDataFromDB:query];
            if(city && city.count > 0){
            continue;
            }
            query = [NSString stringWithFormat:@"insert into cities values(%@,'%@','%@','%@','%@','%@',%f,%f,'%@','%@','%@','%@')",nil,[name urlEncode],[url urlEncode],[country urlEncode],[countrycode urlEncode],[bpid urlEncode],latitude.doubleValue,longitude.doubleValue,[parent urlEncode],[postingurl urlEncode],statecode,[statename urlEncode]];
            [[DBManager sharedInstance] executeQuery:query];
            }
            }];*/
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
