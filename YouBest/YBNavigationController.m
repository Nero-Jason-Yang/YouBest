//
//  YBNavigationController.m
//  YouBest
//
//  Created by Jason Yang on 14-2-24.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "YBNavigationController.h"
#import "AppDelegate.h"
#import "UINavigationBar+Utils.h"
#import "UIView+Utils.h"

@interface YBNavigationController () <UINavigationBarDelegate>
{
    UIView *_adminModeView;
}
@end

@implementation YBNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark public

- (BOOL)adminMode
{
    return !!_adminModeView;
}

- (void)setAdminMode:(BOOL)adminMode
{
    if (adminMode) {
        if (!_adminModeView) {
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
                frame.origin = CGPointZero;
                UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"退出管理"]];
                segmentControl.momentary = YES;
                segmentControl.frame = frame;
                segmentControl.tintColor = [UIColor redColor];
                [segmentControl addTarget:self action:@selector(onAdminBarChanged:) forControlEvents:UIControlEventValueChanged];
                [_adminModeView addSubview:segmentControl];
            }
        }
    }
    else {
        if (_adminModeView) {
            // remove prompt view
            for (UINavigationItem *item in self.navigationBar.items) {
                item.prompt = nil;
            }
            
            // remove admin-mode view
            [_adminModeView removeFromSuperview];
            _adminModeView = nil;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:AdminModeChangedNotification object:[NSNumber numberWithBool:adminMode]];
}

#pragma mark internal

- (IBAction)onAdminBarChanged:(id)sender
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
