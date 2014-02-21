//
//  UIViewController+Utils.m
//  YouBest
//
//  Created by Jason Yang on 14-2-21.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

- (NSDictionary *)inheritanceInfoDic
{
    NSString *name = NSStringFromClass(self.class);
    if (![name isEqualToString:@"UIViewController"]) {
        Class superclass = self.superclass;
        name = [name stringByAppendingFormat:@":%@", NSStringFromClass(superclass) ];
    }
    
    NSMutableArray *subInfoDics = [NSMutableArray array];
    for (UIViewController *sub in self.childViewControllers) {
        [subInfoDics addObject:sub.inheritanceInfoDic];
    }
    return @{name:subInfoDics};
}

@end
