//
//  UITableViewController+Utils.m
//  YouBest
//
//  Created by Jason Yang on 14-2-20.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "UITableViewController+Utils.h"

@implementation UITableViewController (Utils)

- (void)correctTableViewPosition
{
    if (self.navigationItem) {
        UIView *tableview = self.tableView;
        UIView *superview = tableview.superview;
        CGPoint point = [superview convertPoint:CGPointZero fromView:tableview];
        CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
        CGFloat height = navigationBarFrame.origin.y + navigationBarFrame.size.height;
        if (point.y < height) {
            point.y = height;
            CGRect frame = tableview.frame;
            frame.origin = point;
            tableview.frame = frame;
        }
    }
}

@end
