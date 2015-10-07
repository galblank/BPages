//
//  ViewController.h
//  BPages
//
//  Created by Gal Blank on 10/5/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPages-Swift.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ItemDelegate>
{
    UITableView * mainViewTable;
}

-(void)selectedItem:(NSMutableDictionary *)item;
@end

