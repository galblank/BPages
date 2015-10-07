//
//  AppDelegate.m
//  BPages
//
//  Created by Gal Blank on 10/5/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AAShareBubbles/AAShareBubbles.h"
#import "WYPopoverController/WYPopoverController.h"
//#import "MenuViewController.h"
#import "Social/Social.h"
#import "UIKit+AFNetworking.h"
#import "AFContact.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "XmlHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


AppDelegate *shared = nil;


+ (AppDelegate*)shared
{
    return shared;
}

- (id)init
{
    self = [super init];
    
    shared = self;
    return (self);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController * mainVC = [[ViewController alloc] init];
    mainVC.navigationController.navigationBarHidden = YES;
    UINavigationController * rootNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    rootNav.navigationBarHidden = YES;
    self.window.rootViewController = rootNav;
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self showMenuButton];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//////////////////////////PROPRETERY FUNCTiONS/////////////////////////////
-(void)fetchMainItems
{
    NSString *url=@"http://www.lancers.jp/work";
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSDictionary *dict=[XmlHandler dictionaryForXMLData:data error:nil];
    
    NSLog(@"%@",[dict description]);
    
}
-(void)makeacall
{
    if(callwindow == nil){
        callwindow = [[CallingCardView alloc] initWithFrame:CGRectMake(0,-250,self.window.frame.size.width,250)];
        
        [self.window addSubview:callwindow];
    }
    
    callwindow.infoDoc = sharemissingperson;
    [callwindow updateUI];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         callwindow.frame = CGRectMake(0,0,self.window.frame.size.width,250);
                     }
                     completion:^(BOOL finished){
                         [self.window bringSubviewToFront:callwindow];
                     }];
}


-(void)hideCallingCard
{
    if(callwindow){
        [UIView animateWithDuration:0.5
                         animations:^{
                             callwindow.frame = CGRectMake(0,-250,self.window.frame.size.width,250);
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}

-(void)shareThisApp
{
   
}
-(void)contactDeveloper
{
    if(mailComp == nil){
        mailComp = [[MFMailComposeViewController alloc] init];
        [mailComp setMailComposeDelegate:self];
    }
    if ([MFMailComposeViewController canSendMail]) {
        [mailComp setToRecipients:@[@"galblank@gmail.com"]];
        [mailComp setSubject:NSLocalizedString(@"Contact for MissingKids developer", nil)];
        [self.window.rootViewController presentViewController:mailComp animated:YES completion:nil];
    }
}

-(void)shareTheApp{
    if(mailComp == nil){
        mailComp = [[MFMailComposeViewController alloc] init];
        [mailComp setMailComposeDelegate:self];
    }
    
    if ([MFMailComposeViewController canSendMail]) {
        [mailComp setSubject:NSLocalizedString(@"Missing Children and Amber Alerts App", nil)];
        NSString *shareString = [NSString stringWithFormat:@"Download this app, it might help save someone https://itunes.apple.com/us/app/missingkids/id1041399210?ls=1&mt=8"];
        [mailComp setMessageBody:shareString isHTML:YES];
        
        [self.window.rootViewController presentViewController:mailComp animated:YES completion:nil];
    }
}



- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if (error) {
        // Error handling
    }
    [controller dismissViewControllerAnimated:NO completion:nil];
}



- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    
    if(result == MessageComposeResultSent)
    {
        NSLog(@"MessageComposeResultSent");
    }
    
    if(result == MessageComposeResultCancelled)
    {
        NSLog(@"MessageComposeResultCancelled");
    }
    
    if(result == MessageComposeResultFailed)
    {
        NSLog(@"MessageComposeResultCancelled");
    }
    
    
    [messageController dismissViewControllerAnimated:YES completion:^
     {
         
     }];
}

- (void)sendText
{
    NSLog(@"sendText");
    
    if([MFMessageComposeViewController canSendText] == YES)
    {
        ABContactsViewController *abcontact = [[ABContactsViewController alloc] init];
        abcontact.abcontactsDel = self;
        contactsController = [[UINavigationController alloc] initWithRootViewController:abcontact];
        [self.window.rootViewController presentViewController:contactsController animated:YES completion:^
         {
         }];
    }
    else
    {
        NSString *title   = NSLocalizedString(@"Device Settings", nil);
        NSString *message = NSLocalizedString(@"Your device is not currently configured to support sending a message. Please check your device Settings and try again.", nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [alert show];
    }
}

-(void)aaShareBubblesDidHide:(AAShareBubbles *)bubbles {
    NSLog(@"All Bubbles hidden");
}



-(void)popTopViewController
{
    [[self topViewController].navigationController popViewControllerAnimated:YES];
}

-(void)showMenuButton
{
    if(menuButton == nil){
        menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        menuButton.frame = CGRectMake(self.window.frame.size.width - 80, self.window.frame.size.height - 80, 60, 60);
        menuButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        menuButton.layer.borderWidth = 0.3;
        menuButton.alpha = 0.8;
        [menuButton setBackgroundColor:[UIColor whiteColor]];
        [menuButton addTarget:self action:@selector(populateMenu) forControlEvents:UIControlEventTouchUpInside];
        menuButton.layer.cornerRadius = menuButton.frame.size.height / 2;
        [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [self.window addSubview:menuButton];
    }
    menuButton.hidden = NO;
}

-(void)hideMenuButton
{
    if(menuButton){
        menuButton.hidden = YES;
    }
}


- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    popoverController.delegate = nil;
    popoverController = nil;
}



- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    
    
    if (nil == locationManager){
        locationManager = [[CLLocationManager alloc] init];
        [locationManager requestWhenInUseAuthorization];
    }
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
        
    } else {
        return rootViewController;
    }
}

@end
