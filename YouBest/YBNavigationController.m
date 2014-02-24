//
//  YBNavigationController.m
//  YouBest
//
//  Created by Jason Yang on 14-2-24.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "YBNavigationController.h"
#import "UINavigationBar+Utils.h"
#import "UIView+Utils.h"

@interface YBNavigationController () <UINavigationBarDelegate>

@end

@implementation YBNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark public

- (void)setIsExtended:(BOOL)adminEnabled
{
    if (_isExtended != adminEnabled) {
        _isExtended = adminEnabled;
        
        if (adminEnabled) {
            // original navigation bar height
            CGFloat originalHeight = self.navigationBar.frame.size.height;
            
            // extend navigation bar height by add empty promt
            for (UINavigationItem *item in self.navigationBar.items) {
                item.prompt = @"";
            }
            
            // calculate extended height for our tool bar
            CGFloat toolBarHeight = self.navigationBar.frame.size.height - originalHeight;
            // retrieve generated prompt view
            UIView *promptView = self.navigationBar.promptView;
            
            // check whether extended successfully
            if (promptView && toolBarHeight > 0) {
                // calculate tool bar frame
                CGRect frame = promptView.frame;
                CGRect toolBarFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, toolBarHeight);
                
                _extendedView = [[UIView alloc] initWithFrame:toolBarFrame];
                [self.navigationBar addSubview:_extendedView];
                
#ifdef DEBUG
//                _extendedView.backgroundColor = [UIColor lightGrayColor];
#endif
            }
        }
        else {
            for (UINavigationItem *item in self.navigationBar.items) {
                item.prompt = nil;
            }
            
            if (_extendedView) {
                [_extendedView removeFromSuperview];
                _extendedView = nil;
            }
        }
    }
}

#pragma mark internal


#pragma mark <UINavigationBarDelegate>

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    if (self.isExtended) {
        item.prompt = @"";
    }
    else {
        item.prompt = nil;
    }
    
    return YES;
}

@end
