//
//  UINavigationBar+Utils.m
//  YouBest
//
//  Created by Jason Yang on 14-2-24.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "UINavigationBar+Utils.h"

@implementation UINavigationBar (Utils)

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
