//
//  ViewController.m
//  BPages
//
//  Created by Gal Blank on 10/5/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

#import "ViewController.h"
#import "definitions.h"
#import "BPages-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    ItemTableViewController * newItem = [[ItemTableViewController alloc] init];
    [self.navigationController pushViewController:newItem animated:YES];
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
    
    switch (indexPath.row) {
        case MENU_COUNTRY:
            cell.textLabel.text = NSLocalizedString(@"Country", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"None", nil);
            break;
        case MENU_STATE:
            cell.textLabel.text = NSLocalizedString(@"State", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"None", nil);
            break;
        case MENU_CITY:
            cell.textLabel.text = NSLocalizedString(@"City", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"None", nil);
            break;
        case MENU_SECTION:
            cell.textLabel.text = NSLocalizedString(@"Section", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"None", nil);
            break;
        case MENU_CATEGORY:
            cell.textLabel.text = NSLocalizedString(@"Category", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"None", nil);
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
