//
//  UINavigationBar+prompt.m
//  YouBest
//
//  Created by Jason Yang on 14-4-10.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "UINavigationBar+prompt.h"

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