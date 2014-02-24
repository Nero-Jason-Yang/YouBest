//
//  UIView+Utils.m
//  YouBest
//
//  Created by Jason Yang on 14-2-21.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (NSDictionary *)inheritanceInfoDic
{
    NSString *name = NSStringFromClass(self.class);
    if (![name isEqualToString:@"UIView"]) {
        Class superclass = self.superclass;
        name = [name stringByAppendingFormat:@":%@", NSStringFromClass(superclass) ];
    }
    CGRect frame = self.frame;
    name = [name stringByAppendingFormat:@"(%d,%d,%d,%d)", (int)frame.origin.x, (int)frame.origin.y, (int)frame.size.width, (int)frame.size.height];
    
    NSMutableArray *subInfoDics = [NSMutableArray array];
    for (UIView *subview in self.subviews) {
        [subInfoDics addObject:subview.inheritanceInfoDic];
    }
    return @{name:subInfoDics};
}

@end
