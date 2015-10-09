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

@interface ViewController ()

@end

@implementation ViewController

-(void)selectedItem:(NSDictionary<NSString *,id> *)item menuItem:(MENU_TYPES)menuItem
{
    switch (menuItem) {
        case MENU_COUNTRY:
            [tableData setObject:item forKeyedSubscript:@"country"];
            break;
        case MENU_STATE:
        {
            [tableData setObject:item forKeyedSubscript:@"state"];
            NSMutableDictionary * countryDic = [tableData objectForKeyedSubscript:@"country"];
            NSString * country = [countryDic objectForKeyedSubscript:@"alpha2Code"];
            NSString * state = [[tableData objectForKeyedSubscript:@"state"] objectForKeyedSubscript:@"iso"];
            NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
            [params setObject:country forKeyedSubscript:@"CountryCode"];
            [params setObject:state forKeyedSubscript:@"State"];
            NSString * url = [NSString stringWithFormat:@"Site.xml?CountryCode=%@&State=%@",country,state];
            [[CommManager sharedInstance] getAPI:url andParams:nil andDelegate:self];
        }
            break;
        case MENU_CITY:
            [tableData setObject:item forKeyedSubscript:@"city"];
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

-(void)getApiFinished:(NSMutableDictionary*)response
{
    NSXMLParser * parser = [response objectForKeyedSubscript:@"result"];
    NSError * error;
    NSMutableDictionary * document = [XmlHandler dictionaryNSXmlParseObject:parser error:error];
    NSLog(@"%@",document);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableData = [[NSMutableDictionary alloc] init];
    [tableData setObject:NSLocalizedString(@"None", nil) forKeyedSubscript:@"country"];
    [tableData setObject:NSLocalizedString(@"None", nil) forKeyedSubscript:@"state"];
    [tableData setObject:NSLocalizedString(@"None", nil) forKeyedSubscript:@"city"];
    [tableData setObject:NSLocalizedString(@"None", nil) forKeyedSubscript:@"category"];
    [tableData setObject:NSLocalizedString(@"None", nil) forKeyedSubscript:@"section"];
    
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
            if([[tableData objectForKeyedSubscript:@"country"] isKindOfClass:[NSString class]]){
                cell.detailTextLabel.text = [tableData objectForKeyedSubscript:@"country"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
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
