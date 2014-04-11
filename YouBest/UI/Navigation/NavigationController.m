//
//  NavigationController.m
//  YouBest
//
//  Created by Jason Yang on 14-4-8.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "NavigationController.h"
#import "UINavigationBar+prompt.h"
#import "AppDelegate.h"
#import "Notifications.h"

@interface NavigationController ()
@property (nonatomic,readonly) UIView *promptBar;
@property (nonatomic,readonly) UIButton *adminModeQuitButton;
@end

@implementation NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:32.0/255 green:151.0/255 blue:71.0/255 alpha:1]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyAdminModeChanged:) name:AdminModeChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self showPromptBar];
}

#pragma mark (private) prompt bar

- (void)showPromptBar
{
    // original navigation bar height.
    CGFloat navBarHeight = self.navigationBar.frame.size.height;
    
    // enable prompt bar.
    for (UINavigationItem *item in self.navigationBar.items) {
        if (!item.prompt) {
            item.prompt = @"";
        }
    }
    
    // create prompt bar.
    if (!self.promptBar) {
        CGFloat promptHeight = self.navigationBar.frame.size.height - navBarHeight;
        if (0 == promptHeight) {
            promptHeight = 30;
        }
        
        UIView *referView = self.navigationBar.promptView;
        if (!referView) {
            referView = self.navigationBar;
        }
        
        CGRect frame = referView.frame;
        frame.size = CGSizeMake(frame.size.width, promptHeight);
        
        _promptBar = [[UIView alloc] initWithFrame:frame];
    }
    
    // show prompt bar.
    if (!self.promptBar.superview) {
        [self.navigationBar addSubview:self.promptBar];
    }
    
    // fill prompt bar.
    if (0 == self.promptBar.subviews.count) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"退出管理" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onActionAdminModeQuitButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, 0, 80, 24)];
        [button setHidden:![AppDelegate sharedAppDelegate].adminMode];
        [button.layer setCornerRadius:4];
        [button.layer setBorderWidth:1.0];
        [button.layer setBorderColor:UIColor.whiteColor.CGColor];
        [self.promptBar addSubview:button];
        _adminModeQuitButton = button;
    }
}

- (void)keepPromptBar_willPushItem:(UINavigationItem *)item
{
    if (!item.prompt) {
        item.prompt = @"";
    }
}

#pragma mark (private) actions

- (void)onActionAdminModeQuitButtonPress:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AdminModeChangedNotification object:@NO];
}

#pragma mark (private) notifications

- (void)onNotifyAdminModeChanged:(NSNotification *)notification
{
    self.adminModeQuitButton.hidden = ![notification.object boolValue];
}

#pragma mark <UINavigationBarDelegate>

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    [self keepPromptBar_willPushItem:item];
    return YES;
}

@end
