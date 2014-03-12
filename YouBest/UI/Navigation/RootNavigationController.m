//
//  RootNavigationController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "RootNavigationController.h"
#import "Notifications.h"

@interface RootNavigationController ()
{
    UIView *_adminModeView;
}
@end

@interface UINavigationBar (prompt)
@property (readonly) UIView *promptView;
@end

@implementation RootNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark public

- (BOOL)adminMode
{
    return !!_adminModeView;
}

- (void)setAdminMode:(BOOL)adminMode
{
    if (adminMode == self.adminMode) {
        return;
    }
    
    if (adminMode) {
        // original navigation bar height
        CGFloat originalHeight = self.navigationBar.frame.size.height;
        
        // extend navigation bar height by add empty promt
        for (UINavigationItem *item in self.navigationBar.items) {
            item.prompt = @"";
        }
        
        // calculate extended height for our admin-mode view
        CGFloat adminModeViewHeight = self.navigationBar.frame.size.height - originalHeight;
        // retrieve generated prompt view
        UIView *promptView = self.navigationBar.promptView;
        
        // check whether extended successfully
        if (promptView && adminModeViewHeight > 0) {
            // add admin-mode view
            CGRect frame = promptView.frame;
            frame.size = CGSizeMake(frame.size.width, adminModeViewHeight);
            _adminModeView = [[UIView alloc] initWithFrame:frame];
            [self.navigationBar addSubview:_adminModeView];
            
            // fill admin-mode view with a segment control
            CGRect segmentFrame = frame;
            segmentFrame.origin = CGPointZero;
            UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"退出管理"]];
            segmentControl.frame = segmentFrame;
            segmentControl.momentary = YES;
            segmentControl.tintColor = [UIColor redColor];
            [segmentControl addTarget:self action:@selector(onAdminModeQuit:) forControlEvents:UIControlEventValueChanged];
            [_adminModeView addSubview:segmentControl];
            
            // animation for admin-mode-view join.
            _adminModeView.alpha = 0;
            CGFloat frame_origin_y = frame.origin.y;
            frame.origin = CGPointMake(frame.origin.x, frame_origin_y - frame.size.height);
            _adminModeView.frame = frame;
            frame.origin = CGPointMake(frame.origin.x, frame_origin_y);
            [UIView animateWithDuration:0.35 animations:^{
                _adminModeView.alpha = 1;
                _adminModeView.frame = frame;
            }];
        }
    }
    else {
        // remove prompt view
        for (UINavigationItem *item in self.navigationBar.items) {
            item.prompt = nil;
        }
        
        // animation for admin-mode-view quit.
        CGRect frame = _adminModeView.frame;
        frame.origin = CGPointMake(frame.origin.x, -frame.size.height);
        [UIView animateWithDuration:0.35 animations:^{
            _adminModeView.alpha = 0.0;
            _adminModeView.frame = frame;
        } completion:^(BOOL finished) {
            // remove admin-mode view
            [_adminModeView removeFromSuperview];
            _adminModeView = nil;
        }];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AdminModeChangedNotification object:[NSNumber numberWithBool:adminMode]];
}

#pragma mark actions

- (IBAction)onAdminModeQuit:(id)sender
{
    self.adminMode = NO;
}

#pragma mark <UINavigationBarDelegate>

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    if (self.adminMode) {
        item.prompt = @"";
    }
    else {
        item.prompt = nil;
    }
    
    return YES;
}

@end

@implementation UINavigationBar (prompt)

- (UIView *)promptView
{
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass(subview.class) isEqualToString:@"UINavBarPrompt"]) {
            return subview;
        }
    }
    return nil;
}

@end