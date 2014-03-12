//
//  PlayerTabBarController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "PlayerTabBarController.h"

@interface PlayerTabBarController ()

@end

@implementation PlayerTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showFirstPage];
}

#pragma mark private

- (void)showFirstPage
{
    self.selectedIndex = 0;
    UITabBarItem *item = self.tabBar.selectedItem;
    self.navigationItem.title = item.title;
}

#pragma mark <UITabBarDelegate>

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)barItem
{
    self.navigationItem.title = barItem.title;
}

@end

@implementation UIViewController (PlayerTabBarController)

- (PlayerTabBarController *)playerTabBarController
{
    UIViewController *parentViewController = self.parentViewController;
    if ([parentViewController isKindOfClass:PlayerTabBarController.class]) {
        return (PlayerTabBarController *)parentViewController;
    }
    return nil;
}

@end

@implementation UITableViewController (AddButton)

#define AddButton_BackgroundColor_Normal   [UIColor colorWithWhite:0.95 alpha:0.9]
#define AddButton_BackgroundColor_Selected [UIColor colorWithWhite:0.85 alpha:1.0]

- (void)setupAddButton
{
//    NSString *buttonTitle = NSLocalizedString(@"+ 添加任务", @"+ Add Task");
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
//    [btn setTitle:buttonTitle forState:UIControlStateNormal];
//    btn.backgroundColor = AddButton_BackgroundColor_Normal;
//    [btn addTarget:self action:@selector(onAddButtonDown:) forControlEvents:UIControlEventTouchDown];
//    [btn addTarget:self action:@selector(onAddButtonUpInside:) forControlEvents:UIControlEventTouchUpInside];
//    [btn addTarget:self action:@selector(onAddButtonUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
//    
//    _addButton = btn;
//    _footerView = [[UIView alloc] initWithFrame:btn.frame];
}

@end