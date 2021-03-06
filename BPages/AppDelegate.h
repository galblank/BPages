//
//  AppDelegate.h
//  BPages
//
//  Created by Gal Blank on 10/5/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WYPopoverController.h"
#import <MessageUI/MessageUI.h>
#import "ABContactsViewController.h"
#import "CallingCardView.h"




@interface AppDelegate : UIResponder <UIApplicationDelegate,WYPopoverControllerDelegate,ABContactsDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation* location;
    NSString *apnsToken;
    UIButton *menuButton;
    WYPopoverController* popoverController;
    NSMutableArray *sharemissingperson;
    MFMailComposeViewController *mailComp;
    UINavigationController * contactsController;
    MFMessageComposeViewController *messageController;
    CallingCardView * callwindow;
    BOOL bShouldUpdateLocation;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *gotoCaseID;
@property (strong, nonatomic) NSMutableDictionary * currentSelectionDic;
+ (AppDelegate*)shared;

-(void)changeMenuButton;
-(void)showMenuButton;
-(void)hideMenuButton;


-(void)CancelSmsSending;
-(void)finishSendingSms:(NSArray*)theList;

@end

