//
//  PlayerTabBarController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "PlayerTabBarController.h"
#import "AppDelegate.h"
#import "Notifications.h"

@interface PlayerTabBarController ()

@end

@implementation PlayerTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showFirstPage];
}

#pragma mark public

#pragma mark private

- (void)showFirstPage
{
    self.selectedIndex = 0;
    UITabBarItem *item = self.tabBar.selectedItem;
    self.navigationItem.title = item.title;
}

#pragma mark actions

- (IBAction)onAdminModeChange:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AdminModeChangedNotification object:@YES];
}

#pragma mark <UITabBarDelegate>

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)barItem
{
    self.navigationItem.title = barItem.title;
}

@end
