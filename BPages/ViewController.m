//
//  ViewController.m
//  BPages
//
//  Created by Gal Blank on 10/5/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

#import "ViewController.h"
#import "definitions.h"
#import "XmlHandler.h"
#import "StringHelper.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)selectedItem:(NSDictionary<NSString *,id> *)item menuItem:(MENU_TYPES)menuItem
{
    switch (menuItem) {
        case MENU_COUNTRY:
            [tableData setObject:item forKeyedSubscript:@"country"];
        {
            NSMutableDictionary * countryDic = [tableData objectForKeyedSubscript:@"country"];
            NSString * country = [countryDic objectForKeyedSubscript:@"alpha2Code"];
            [[AppDelegate shared].currentSelectionDic setObject:country forKeyedSubscript:@"country"];
            [[NSUserDefaults standardUserDefaults] setObject:[AppDelegate shared].currentSelectionDic forKey:@"currentSelectionDic"];
            
            NSString * api = [NSString stringWithFormat:@"Site.xml?CountryCode=%@",country];
            [[CommManager sharedInstance] getAPIBlockWithPrefix:ROOT_API andApi:api andParams:nil completion:^(NSMutableDictionary * result) {
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
            }];

        }
            break;
        case MENU_STATE:
        {
            NSString * state = [item objectForKeyedSubscript:@"iso"];
            [[AppDelegate shared].currentSelectionDic setObject:state forKeyedSubscript:@"state"];
            [[NSUserDefaults standardUserDefaults] setObject:[AppDelegate shared].currentSelectionDic forKey:@"currentSelectionDic"];
            [tableData setObject:item forKeyedSubscript:@"state"];
        }
            break;
        case MENU_CITY:
        {
            [tableData setObject:item forKeyedSubscript:@"city"];
            [[AppDelegate shared].currentSelectionDic setObject:[item objectForKeyedSubscript:@"name"] forKeyedSubscript:@"city"];
            [[NSUserDefaults standardUserDefaults] setObject:[AppDelegate shared].currentSelectionDic forKey:@"currentSelectionDic"];
            //http://losangeles.backpage.com/online/api/Section.xml
            NSMutableDictionary * cityDic = [tableData objectForKeyedSubscript:@"city"];
            NSString * cityurl = [cityDic objectForKeyedSubscript:@"url"];
            [[CommManager sharedInstance] getAPIBlockWithPrefix:cityurl andApi:@"Section.xml" andParams:nil completion:^(NSMutableDictionary * result) {
                NSXMLParser * parser = [result objectForKeyedSubscript:@"result"];
                NSError * error;
                NSMutableDictionary * document = [[XmlHandler dictionaryNSXmlParseObject:parser error:error] mutableCopy];
                NSMutableArray * caegories = [[[document objectForKeyedSubscript:@"rss"] objectForKey:@"channel"] objectForKey:@"item"];
                for(NSMutableDictionary * oneCategory in caegories){
                    NSLog(@"%@",oneCategory);
                    NSString * catId = [[[oneCategory objectForKeyedSubscript:@"bp:Id"] objectForKeyedSubscript:@"bp:Id"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString * catName = [[[oneCategory objectForKeyedSubscript:@"bp:Name"] objectForKeyedSubscript:@"bp:Name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString * catPosition = [[[oneCategory objectForKeyedSubscript:@"bp:Position"] objectForKeyedSubscript:@"bp:Position"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString * catsectionKey = [[[oneCategory objectForKeyedSubscript:@"bp:SectionKey"] objectForKeyedSubscript:@"bp:SectionKey"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString * catsectionShortName = [[[oneCategory objectForKeyedSubscript:@"bp:ShortName"] objectForKeyedSubscript:@"bp:ShortName"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString * catsectionUrl = [[[oneCategory objectForKeyedSubscript:@"bp:URL"] objectForKeyedSubscript:@"bp:URL"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    NSString * query = [NSString stringWithFormat:@"select * from category where catid = '%@'",catId];
                    NSArray * cat = [[DBManager sharedInstance] loadDataFromDB:query];
                    if(cat && cat.count > 0){
                        continue;
                    }
                    query = [NSString stringWithFormat:@"insert into category values(%@,'%@','%@','%@','%@','%@','%@')",nil,[catId urlEncode],[catName urlEncode],[catPosition urlEncode],[catsectionKey urlEncode],[catsectionShortName urlEncode],[catsectionUrl urlEncode]];
                    [[DBManager sharedInstance] executeQuery:query];
                    
                }
            }];
    }
            break;
        case MENU_CATEGORY:
            [tableData setObject:item forKeyedSubscript:@"category"];
            break;
        case MENU_SECTION:
            [tableData setObject:item forKeyedSubscript:@"section"];
            break;
        default:
            break;
    }
    [mainViewTable reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableData = [[NSMutableDictionary alloc] init];
    if([[AppDelegate shared].currentSelectionDic objectForKeyedSubscript:@"country"]){
        [tableData setObject:[[AppDelegate shared].currentSelectionDic objectForKeyedSubscript:@"country"] forKeyedSubscript:@"country"];
    }
    else{
        [tableData setObject:NSLocalizedString(@"None", nil) forKeyedSubscript:@"country"];
    }
    
    if([[AppDelegate shared].currentSelectionDic objectForKeyedSubscript:@"state"]){
        [tableData setObject:[[AppDelegate shared].currentSelectionDic objectForKeyedSubscript:@"state"] forKeyedSubscript:@"state"];
    }
    else{
        [tableData setObject:NSLocalizedString(@"None", nil) forKeyedSubscript:@"state"];
    }
    
    if([[AppDelegate shared].currentSelectionDic objectForKeyedSubscript:@"city"]){
        [tableData setObject:[[AppDelegate shared].currentSelectionDic objectForKeyedSubscript:@"city"] forKeyedSubscript:@"city"];
    }
    else{
        [tableData setObject:NSLocalizedString(@"None", nil) forKeyedSubscript:@"city"];
    }
    
    if([[AppDelegate shared].currentSelectionDic objectForKeyedSubscript:@"category"]){
        [tableData setObject:[[AppDelegate shared].currentSelectionDic objectForKeyedSubscript:@"category"] forKeyedSubscript:@"category"];
    }
    else{
        [tableData setObject:NSLocalizedString(@"None", nil) forKeyedSubscript:@"category"];
    }
    
    
    
    if([[AppDelegate shared].currentSelectionDic objectForKeyedSubscript:@"section"]){
        [tableData setObject:[[AppDelegate shared].currentSelectionDic objectForKeyedSubscript:@"section"] forKeyedSubscript:@"section"];
    }
    else{
        [tableData setObject:NSLocalizedString(@"None", nil) forKeyedSubscript:@"section"];
    }
    
    mainViewTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    mainViewTable.dataSource = self;
    mainViewTable.delegate = self;
    [self.view addSubview:mainViewTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle == UITableViewCellSelectionStyleNone) {
        return;
    }
    
    if(newItemVC == nil){
        newItemVC = [[ItemTableViewController alloc] init];
        newItemVC.delegate = self;
    }
    newItemVC.itemType = (MENU_TYPES)(indexPath.row);
    [newItemVC updateItemsForMenuType];
    [self.navigationController pushViewController:newItemVC animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return(indexPath);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kSSAutoCompleteCell = @"kMainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSSAutoCompleteCell];
    
    if(cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSSAutoCompleteCell];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor blackColor]]; //[UIColor colorWithRed:54.0 / 255.0 green:154.0 / 255.0 blue:238.0 / 255.0 alpha:0.9]];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25.0]];
        cell.accessoryType             = UITableViewCellAccessoryNone;
        cell.textLabel.numberOfLines   = 0;
        cell.selectionStyle            = UITableViewCellSelectionStyleGray;
        cell.backgroundColor           = [UIColor whiteColor];
        
        [cell.detailTextLabel setTextColor:[UIColor blackColor]]; //[UIColor colorWithRed:54.0 / 255.0 green:154.0 / 255.0 blue:238.0 / 255.0 alpha:0.9]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (indexPath.row) {
        case MENU_COUNTRY:
            cell.textLabel.text = NSLocalizedString(@"Country", nil);
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            if([[tableData objectForKeyedSubscript:@"country"] isKindOfClass:[NSString class]]){
                cell.detailTextLabel.text = [tableData objectForKeyedSubscript:@"country"];
            }
            else{
                NSMutableDictionary * item = [tableData objectForKeyedSubscript:@"country"];
                cell.detailTextLabel.text = [item objectForKeyedSubscript:@"name"];
            }
            break;
        case MENU_STATE:
            cell.textLabel.text = NSLocalizedString(@"State", nil);
            if([[tableData objectForKeyedSubscript:@"state"] isKindOfClass:[NSString class]]){
                cell.detailTextLabel.text = [tableData objectForKeyedSubscript:@"state"];
                if([[tableData objectForKeyedSubscript:@"country"] isKindOfClass:[NSString class]] == NO){
                   [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                }
            }
            else{
                NSMutableDictionary * item = [tableData objectForKeyedSubscript:@"state"];
                cell.detailTextLabel.text = [item objectForKeyedSubscript:@"name"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            }
            break;
        case MENU_CITY:
            cell.textLabel.text = NSLocalizedString(@"City", nil);
            if([[tableData objectForKeyedSubscript:@"city"] isKindOfClass:[NSString class]]){
                cell.detailTextLabel.text = [tableData objectForKeyedSubscript:@"city"];
                if([[tableData objectForKeyedSubscript:@"state"] isKindOfClass:[NSString class]] == NO){
                    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                }
            }
            else{
                NSMutableDictionary * item = [tableData objectForKeyedSubscript:@"city"];
                cell.detailTextLabel.text = [item objectForKeyedSubscript:@"name"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            }
            break;
        case MENU_SECTION:
            cell.textLabel.text = NSLocalizedString(@"Section", nil);
            if([[tableData objectForKeyedSubscript:@"section"] isKindOfClass:[NSString class]]){
                cell.detailTextLabel.text = [tableData objectForKeyedSubscript:@"section"];
            }
            else{
                NSMutableDictionary * item = [tableData objectForKeyedSubscript:@"section"];
                cell.detailTextLabel.text = [item objectForKeyedSubscript:@"name"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            }
            break;
        case MENU_CATEGORY:
            cell.textLabel.text = NSLocalizedString(@"Category", nil);
            if([[tableData objectForKeyedSubscript:@"category"] isKindOfClass:[NSString class]]){
                cell.detailTextLabel.text = [tableData objectForKeyedSubscript:@"category"];
            }
            else{
                NSMutableDictionary * item = [tableData objectForKeyedSubscript:@"category"];
                cell.detailTextLabel.text = [item objectForKeyedSubscript:@"name"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            }
            break;
        default:
        
            break;
    }
    
    return(cell);
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

@end
