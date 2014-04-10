//
//  NavigationController.m
//  YouBest
//
//  Created by Jason Yang on 14-4-8.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "NavigationController.h"
#import "UINavigationBar+prompt.h"
#import "Notifications.h"

@interface NavigationController ()
@property (nonatomic,readonly) UIButton *adminModeQuitButton;
@end

@implementation NavigationController
{
    CGFloat _navBarOriginHeight;
    CGFloat _navBarPromptHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _adminModeQuitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_adminModeQuitButton setTitle:@"退出管理" forState:UIControlStateNormal];
    [_adminModeQuitButton addTarget:self action:@selector(onActionAdminModeQuitButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    //[_adminModeQuitButton setFrame:CGRectMake(0, 0, 120, 30)];
    [_adminModeQuitButton setBackgroundColor:[UIColor brownColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (0 == _navBarOriginHeight) {
        _navBarOriginHeight = self.navigationBar.frame.size.height;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (0 == _navBarPromptHeight) {
        _navBarPromptHeight = self.navigationBar.frame.size.height - _navBarOriginHeight;
    }
    
    if (!self.adminModeQuitButton.superview) {
        UIView *promptView = self.navigationBar.promptView;
        if (promptView) {
            CGRect frame = promptView.frame;
            frame.size = CGSizeMake(frame.size.width, _navBarPromptHeight);
            self.adminModeQuitButton.frame = frame;
            
            [self.navigationBar addSubview:self.adminModeQuitButton];
            //[promptView addSubview:self.adminModeQuitButton];
        }
    }
}

#pragma mark public

- (BOOL)hiddenOfAdminModeQuitButton
{
    return self.adminModeQuitButton.hidden;
}

- (void)setHiddenOfAdminModeQuitButton:(BOOL)hidden
{
    self.adminModeQuitButton.hidden = hidden;
}

#pragma mark private

- (void)onActionAdminModeQuitButtonPress:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AdminModeChangedNotification object:@NO];
}

#pragma mark <UINavigationBarDelegate>

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    // Always show prompt view.
    item.prompt = @"";
    
    return YES;
}

@end
