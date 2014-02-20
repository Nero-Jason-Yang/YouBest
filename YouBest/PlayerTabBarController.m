//
//  PlayerTabBarController.m
//  YouBest
//
//  Created by Yang Jason on 14-1-21.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "PlayerTabBarController.h"
#import "InstanceTabBarItem.h"
#import "InstanceListViewController.h"

@interface PlayerTabBarController ()

@end

@implementation PlayerTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTabItems];
}

#pragma mark private

- (void)setupTabItems
{
    NSArray *titles = @[@"任务", @"礼物", @"愿望"];
    NSArray *types = @[[NSNumber numberWithShort:YBItemType_Task], [NSNumber numberWithShort:YBItemType_Gift], [NSNumber numberWithShort:YBItemType_Wish]];
    
    int i = 0;
    for (InstanceTabBarItem *item in self.tabBar.items) {
        if ([item isKindOfClass:InstanceTabBarItem.class]) {
            if (i < titles.count) {
                item.title = titles[i];
            }
            if (i < types.count) {
                item.type = ((NSNumber *)types[i]).shortValue;
            }
            i ++;
        }
    }
}

@end
