//
//  AppDelegate.m
//  YouBest
//
//  Created by Jason Yang on 14-1-14.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "AppDelegate.h"
#import "NSManagedObjectContext+Utils.h"
#import "PlayerMO.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _managedObjectContext = [NSManagedObjectContext contextWithModelName:@"YouBest"];
    NSUInteger numPlayers = [self.managedObjectContext fetchCountForEntityName:@"Player" withPredicate:nil];
    if (0 == numPlayers) {
        // make a default player
        PlayerMO *player = [self.managedObjectContext createObjectForEntityName:@"Player"];
        player.birthday = NSDate.date;
        player.name = @"宝贝";
        player.money = [NSNumber numberWithInteger:0];
        [self.managedObjectContext save];
        numPlayers = 1;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"YouBest" bundle:nil];
    self.window.rootViewController = storyboard.instantiateInitialViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.managedObjectContext save];
}

@end
