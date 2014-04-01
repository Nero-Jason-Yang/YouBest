//
//  UIButton+UITableView.m
//  YouBest
//
//  Created by Jason Yang on 14-4-1.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "UIButton+UITableView.h"

@implementation UIButton (UITableView)

+ (id)tableViewHeaderButtonWithTitle:(NSString *)title action:(SEL)action target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 0, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.9];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
