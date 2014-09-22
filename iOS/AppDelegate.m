//
//  AppDelegate.m
//  Stage
//
<<<<<<< HEAD
//  Created by Robby on 9/19/14.
=======
//  Created by Robby on 6/27/14.
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
//  Copyright (c) 2014 Robby. All rights reserved.
//

#import "AppDelegate.h"
#import "Stage.h"
#import "SWRevealViewController.h"
#import "MenuViewController.h"

@interface AppDelegate () <SWRevealViewControllerDelegate>
<<<<<<< HEAD
            

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
=======
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    Stage *stage = [[Stage alloc] init];
    MenuViewController *menu = [[MenuViewController alloc] init];
<<<<<<< HEAD

=======
    
>>>>>>> 71b2221663ac7ac7d1bc71a7807620b95db9a580
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:menu frontViewController:stage];

    [mainRevealController setDelegate:self];
//    [mainRevealController setRearViewRevealWidth:60];
//    [mainRevealController setRearViewRevealOverdraw:120];
//    [mainRevealController setBounceBackOnOverdraw:NO];
//    [mainRevealController setStableDragOnOverdraw:YES];
//    [mainRevealController setFrontViewPosition:FrontViewPositionRight];
    
    self.window.rootViewController = mainRevealController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
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

@end
