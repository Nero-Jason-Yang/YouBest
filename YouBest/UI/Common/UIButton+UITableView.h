//
//  UIButton+UITableView.h
//  YouBest
//
//  Created by Jason Yang on 14-4-1.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UITableView)

+ (id)tableViewHeaderButtonWithTitle:(NSString *)title action:(SEL)action target:(id)target;

@end
