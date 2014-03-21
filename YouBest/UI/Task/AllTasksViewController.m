//
//  AllTasksViewController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "AllTasksViewController.h"
#import "PlayerTabBarController.h"
#import "ButtonDockedTableView.h"
#import "UITableViewExtra.h"
#import "AppDelegate.h"
#import "Notifications.h"
#import "Database.h"
#import "YBPlayer.h"
#import "YBTaskInstance.h"

@interface AllTasksViewController ()
{
    NSArray *_tasks;
    UITableViewExtra *_extra;
    UITableViewCell *_headCell;
}
@end

@implementation AllTasksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"任务", @"Task");
    
    [self updateDataSourceDown];
    [self didChangeAdminMode:((AppDelegate *)(UIApplication.sharedApplication.delegate)).adminMode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdminModeChanged:) name:AdminModeChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    [self didChangeAdminMode:((AppDelegate *)(UIApplication.sharedApplication.delegate)).adminMode];
}

#pragma mark public

- (void)updateDataSourceDown
{
    YBPlayer *player = self.playerTabBarController.player;
    NSParameterAssert(player);
    if (!player) {
        _tasks = nil;
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    Database *db = Database.sharedDatabase;
    [db.context performBlockAndWait:^{
        NSArray *mos = [db fetchAllTaskInstancesForPlayerID:player.identity];
        for (MOTaskInstance *mo in mos) {
            YBTaskInstance *task = [[YBTaskInstance alloc] initWithMO:mo];
            if (task) {
                [array addObject:task];
            }
        }
    }];
    
    dispatch_block_t block = ^{
        _tasks = array;
    };
    
    if (NSThread.isMainThread) {
        block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

#pragma mark private

- (void)onAdminModeChanged:(id)sender
{
    NSNotification *notification = sender;
    NSParameterAssert([notification isKindOfClass:NSNotification.class]);
    NSNumber *number = notification.object;
    NSParameterAssert([number isKindOfClass:NSNumber.class]);
    [self didChangeAdminMode:number.boolValue];
}

- (void)didChangeAdminMode:(BOOL)adminMode
{
    if (adminMode) {
        if (!_extra) {
            _extra = [[UITableViewExtra alloc] initWithViewController:self];
        }
        if (!_headCell) {
            CGRect frame = self.tableView.frame;
            frame.size = CGSizeMake(frame.size.width, 44);
            _headCell = [[UITableViewCell alloc] initWithFrame:frame];
        }
        
        [_extra setHeadCell:_headCell forSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [_extra setHeadCell:nil forSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_extra) {
        return _tasks.count + [_extra extraNumberOfRowsInSection:section];
    }
    
    return _tasks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_extra) {
        NSNumber *height = [_extra heightForRowAtIndexPath:indexPath];
        if (height) {
            return height.floatValue;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_extra) {
        UITableViewCell *cell = [_extra cellForRowAtIndexPath:indexPath];
        if (cell) {
            return cell;
        }
        indexPath = [_extra indexPathWithoutExtraForIndexPath:indexPath];
    }
    
    static NSString *CellIdentifier = @"Cell";
    AllTasksViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    YBTaskInstance *task = _tasks[indexPath.row];
    cell.title.text = task.title;
    cell.value.text = [NSString stringWithFormat:@"%d", (int)task.value.integerValue];
    
    return cell;
}

@end

@implementation AllTasksViewCell

@end
