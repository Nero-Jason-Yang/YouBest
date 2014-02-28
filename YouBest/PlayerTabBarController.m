//
//  PlayerTabBarController.m
//  YouBest
//
//  Created by Yang Jason on 14-1-21.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "PlayerTabBarController.h"
#import "InstanceListViewController.h"
#import "YBNavigationController.h"
#import "UIView+Utils.h"

@interface PlayerTabBarController ()

@property (strong, nonatomic) IBOutlet UIButton *navigationItemRightButton;

@end

@implementation PlayerTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTabItems];
    
    [self showFirstPage];
}

- (IBAction)onAdminMode:(id)sender
{
//    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Password" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    view.alertViewStyle = UIAlertViewStyleSecureTextInput;
//    [view show];
    
    YBNavigationController *nc = (YBNavigationController *)self.navigationController;
    if ([nc isKindOfClass:YBNavigationController.class]) {
        nc.adminMode = !nc.adminMode;
    }
}

#pragma mark private

- (void)setupTabItems
{
    NSArray *titles = @[@"任务", @"礼物", @"愿望"];
    NSArray *types = @[[NSNumber numberWithShort:YBItemType_Task], [NSNumber numberWithShort:YBItemType_Gift], [NSNumber numberWithShort:YBItemType_Wish]];
    
    int i = 0;
    for (InstanceListViewTabBarItem *item in self.tabBar.items) {
        if ([item isKindOfClass:InstanceListViewTabBarItem.class]) {
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
    
    if ([barItem isKindOfClass:InstanceListViewTabBarItem.class]) {
        InstanceListViewTabBarItem *item = (InstanceListViewTabBarItem *)barItem;
        switch (item.type) {
            case YBItemType_Task:
            case YBItemType_Gift:
                self.navigationItemRightButton.imageView.image = [UIImage imageNamed:@"coin_16.png"];
                break;
                
            case YBItemType_Wish: {
                self.navigationItemRightButton.imageView.image = [UIImage imageNamed:@"gift_16.png"];
                self.navigationItemRightButton.titleLabel.text = @"123456";
                UILabel *label = self.navigationItemRightButton.titleLabel;
                label.autoresizesSubviews = YES;
                self.navigationItemRightButton.autoresizesSubviews = YES;
            }
                break;
                
            default:
                break;
        }
    }
}

@end
