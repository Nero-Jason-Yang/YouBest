//
//  UITableViewExtension.m
//  YouBest
//
//  Created by Jason Yang on 14-3-24.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "UITableViewExtension.h"

@interface ExtensionCellInfo : NSObject
@property (nonatomic) NSNumber *height;
@property (nonatomic) NSString *identifier;
@end

@implementation ExtensionCellInfo
@end

@interface ExtensionSectionInfo : NSObject
@property (nonatomic,readonly) ExtensionCellInfo *head;
@property (nonatomic,readonly) ExtensionCellInfo *tail;
@end

@implementation ExtensionSectionInfo
- (id)init {
    if (self = [super init]) {
        _head = [[ExtensionCellInfo alloc] init];
        _tail = [[ExtensionCellInfo alloc] init];
    }
    return self;
}
@end

@implementation UITableViewExtension
{
    UITableView __weak *_tableView;
    NSMutableDictionary *_infosBySection;
}

- (id)initWithTableView:(UITableView *)tableView
{
    if (self = [super init]) {
        NSParameterAssert(tableView);
        _tableView = tableView;
    }
    return self;
}

- (void)registerExtraCellClass:(Class)cellClass withReuseIdentifier:(NSString *)identifier forSection:(NSInteger)section direction:(NSInteger)direction
{
    ExtensionSectionInfo *info = [self infoForSection:section createIfNotFound:YES];
    if (direction == UITableViewExtension_ExtraCellDirection_Head) {
        info.head.identifier = identifier;
    }
    else if (direction == UITableViewExtension_ExtraCellDirection_Tail) {
        info.tail.identifier = identifier;
    }
    [_tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

- (void)setExtraCellHeight:(NSNumber *)height forSection:(NSInteger)section direction:(NSInteger)direction withRowAnimation:(UITableViewRowAnimation)animation
{
    ExtensionSectionInfo *info = [self infoForSection:section];
    if (info) {
        if (direction == UITableViewExtension_ExtraCellDirection_Head) {
            NSNumber *old = info.head.height;
            info.head.height = height;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            if (old) {
                if (height) {
                    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
                }
                else {
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
                }
            }
            else {
                if (height) {
                    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
                }
            }
        }
        else if (direction == UITableViewExtension_ExtraCellDirection_Tail) {
            NSInteger number = [_tableView.dataSource tableView:_tableView numberOfRowsInSection:section];
            
            NSNumber *old = info.tail.height;
            info.tail.height = height;
            
            if (old) {
                NSParameterAssert(number > 0);
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(number-1) inSection:section];
                if (height) {
                    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
                }
                else {
                    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
                }
            }
            else {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number inSection:section];
                if (height) {
                    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
                }
            }
        }
    }
}

- (NSNumber *)heightOfExtraCellForSection:(NSInteger)section direction:(NSInteger)direction
{
    ExtensionSectionInfo *info = [self infoForSection:section];
    if (info) {
        if (direction == UITableViewExtension_ExtraCellDirection_Head) {
            return info.head.height;
        }
        else if (direction == UITableViewExtension_ExtraCellDirection_Tail) {
            return info.tail.height;
        }
    }
    return nil;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    ExtensionSectionInfo *info = [self infoForSection:section];
    if (info) {
        if (info.head.height) {
            number ++;
        }
        if (info.tail.height) {
            number ++;
        }
    }
    return number;
}

- (NSNumber *)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExtensionSectionInfo *info = [self infoForSection:indexPath.section];
    if (info) {
        if ([self isHeadCellForIndexPath:indexPath]) {
            if (info.head.height) {
                return info.head.height;
            }
        }
        else if ([self isTailCellForIndexPath:indexPath]) {
            if (info.tail.height) {
                return info.tail.height;
            }
        }
    }
    return nil;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath **)pIndexPath
{
    NSIndexPath *indexPath = *pIndexPath;
    ExtensionSectionInfo *info = [self infoForSection:indexPath.section];
    if (info) {
        if ([self isHeadCellForIndexPath:indexPath]) {
            if (info.head.height) {
                UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:info.head.identifier];
                NSParameterAssert(cell);
                if (cell) {
                    CGRect frame = CGRectZero;
                    frame.size = CGSizeMake(_tableView.frame.size.width, info.head.height.floatValue);
                    cell.frame = frame;
                    return cell;
                }
            }
        }
        else if ([self isTailCellForIndexPath:indexPath]) {
            if (info.tail.height) {
                UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:info.tail.identifier];
                NSParameterAssert(cell);
                if (cell) {
                    CGRect frame = CGRectZero;
                    frame.size = CGSizeMake(_tableView.frame.size.width, info.tail.height.floatValue);
                    cell.frame = frame;
                    return cell;
                }
            }
        }
        
        if (info.head.height) {
            if (indexPath.row > 0) {
                *pIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
            }
        }
    }
    return nil;
}

- (BOOL)isExtraCellForDirection:(NSInteger)direction withIndexPath:(NSIndexPath *)indexPath
{
    return [self isExtraCellForDirection:direction withIndexPath:indexPath getHeight:nil];
}

#pragma mark private

- (ExtensionSectionInfo *)infoForSection:(NSInteger)section
{
    return [self infoForSection:section createIfNotFound:NO];
}

- (ExtensionSectionInfo *)infoForSection:(NSInteger)section createIfNotFound:(BOOL)create
{
    if (!_infosBySection && create) {
        _infosBySection = [NSMutableDictionary dictionary];
    }
    ExtensionSectionInfo *info = [_infosBySection objectForKey:[NSNumber numberWithInteger:section]];
    if (!info && create) {
        info = [[ExtensionSectionInfo alloc] init];
        [_infosBySection setObject:info forKey:[NSNumber numberWithInteger:section]];
    }
    return info;
}

- (BOOL)isHeadCellForIndexPath:(NSIndexPath *)indexPath
{
    return (0 == indexPath.row);
}

- (BOOL)isTailCellForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfRows = [_tableView.dataSource tableView:_tableView numberOfRowsInSection:indexPath.section];
    return (numberOfRows == indexPath.row + 1);
}

- (BOOL)isExtraCellForDirection:(NSInteger)direction withIndexPath:(NSIndexPath *)indexPath getHeight:(NSNumber **)height
{
    NSParameterAssert(indexPath);
    
    ExtensionSectionInfo *info = [self infoForSection:indexPath.section];
    if (info) {
        if (direction == UITableViewExtension_ExtraCellDirection_Head) {
            if ([self isHeadCellForIndexPath:indexPath]) {
                if (info.head.height) {
                    if (height) {
                        *height = info.head.height;
                    }
                    return YES;
                }
            }
        }
        else if (direction == UITableViewExtension_ExtraCellDirection_Tail) {
            if ([self isTailCellForIndexPath:indexPath]) {
                if (info.tail.height) {
                    if (height) {
                        *height = info.tail.height;
                    }
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

@end
