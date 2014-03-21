//
//  UITableViewExtra.m
//  YouBest
//
//  Created by Jason Yang on 14-3-21.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "UITableViewExtra.h"

@implementation UITableViewExtra
{
    UITableView __weak *_tableView;
    UITableViewController __weak *_viewController;
    NSMutableDictionary *_headCells;
    NSMutableDictionary *_tailCells;
}

- (id)initWithViewController:(UITableViewController *)viewController
{
    if (self = [super init]) {
        NSParameterAssert(viewController);
        _viewController = viewController;
        _tableView = viewController.tableView;
    }
    return self;
}

- (id)initWithViewController:(UITableViewController *)viewController tableView:(UITableView *)tableView
{
    if (self = [super init]) {
        NSParameterAssert(viewController);
        _viewController = viewController;
        _tableView = tableView ? tableView : viewController.tableView;
    }
    return self;
}

// data

- (UITableViewCell *)headCellForSection:(NSInteger)section
{
    return [_headCells objectForKey:[NSNumber numberWithInteger:section]];
}

- (UITableViewCell *)tailCellForSection:(NSInteger)section
{
    return [_tailCells objectForKey:[NSNumber numberWithInteger:section]];
}

// UI

- (void)setHeadCell:(UITableViewCell *)cell forSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
    UITableViewCell *old = [self headCellForSection:section];
    [self setHeadCell:cell forSection:section];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    if (old) {
        if (cell) {
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        }
        else {
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        }
    }
    else {
        if (cell) {
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        }
    }
}

- (void)setTailCell:(UITableViewCell *)cell forSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
    NSInteger number = [_tableView numberOfRowsInSection:section];
    UITableViewCell *old = [self tailCellForSection:section];
    [self setTailCell:cell forSection:section];
    
    if (old) {
        NSParameterAssert(number > 0);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(number-1) inSection:section];
        if (cell) {
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        }
        else {
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        }
    }
    else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number inSection:section];
        if (cell) {
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
        }
    }
}

// helper

- (NSInteger)extraNumberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if ([self headCellForSection:section]) {
        number ++;
    }
    if ([self tailCellForSection:section]) {
        number ++;
    }
    return number;
}

- (NSNumber *)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    if (cell) {
        return [NSNumber numberWithFloat:cell.frame.size.height];
    }
    return nil;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([self isHeadCellForRowAtIndexPath:indexPath]) {
        cell = [self headCellForSection:indexPath.section];
    }
    else if ([self isTailCellForRowAtIndexPath:indexPath]) {
        cell = [self tailCellForSection:indexPath.section];
    }
    return cell;
}

- (NSIndexPath *)indexPathWithoutExtraForIndexPath:(NSIndexPath *)indexPath
{
    if ([self headCellForSection:indexPath.section]) {
        NSParameterAssert(indexPath.row > 0);
        return [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    }
    else {
        return indexPath;
    }
}

#pragma mark private

- (void)setHeadCell:(UITableViewCell *)cell forSection:(NSInteger)section
{
    if (cell) {
        if (!_headCells) {
            _headCells = [NSMutableDictionary dictionary];
        }
        [_headCells setObject:cell forKey:[NSNumber numberWithInteger:section]];
    }
    else if (_headCells) {
        [_headCells removeObjectForKey:[NSNumber numberWithInteger:section]];
    }
}

- (void)setTailCell:(UITableViewCell *)cell forSection:(NSInteger)section
{
    if (cell) {
        if (!_tailCells) {
            _tailCells = [NSMutableDictionary dictionary];
        }
        [_tailCells setObject:cell forKey:[NSNumber numberWithInteger:section]];
    }
    else if (_tailCells) {
        [_tailCells removeObjectForKey:[NSNumber numberWithInteger:section]];
    }
}

- (BOOL)isHeadCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (0 == indexPath.row);
}

- (BOOL)isTailCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfRows = [_viewController tableView:_tableView numberOfRowsInSection:indexPath.section];
    return (numberOfRows == indexPath.row + 1);
}

@end
