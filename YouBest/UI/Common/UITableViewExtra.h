//
//  UITableViewExtra.h
//  YouBest
//
//  Created by Jason Yang on 14-3-21.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewExtra : NSObject
- (id)initWithViewController:(UITableViewController *)viewController;
- (id)initWithViewController:(UITableViewController *)viewController tableView:(UITableView *)tableView;
// data
- (UITableViewCell *)headCellForSection:(NSInteger)section;
- (UITableViewCell *)tailCellForSection:(NSInteger)section;
// UI
- (void)setHeadCell:(UITableViewCell *)cell forSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)setTailCell:(UITableViewCell *)cell forSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
// helper
- (NSInteger)extraNumberOfRowsInSection:(NSInteger)section;
- (NSNumber *)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathWithoutExtraForIndexPath:(NSIndexPath *)indexPath;
@end
