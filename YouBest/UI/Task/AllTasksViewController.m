//
//  AllTasksViewController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "AllTasksViewController.h"
#import "PlayerTabBarController.h"
#import "UITableViewExtension.h"
#import "TaskEditingViewController.h"
#import "AppDelegate.h"
#import "Notifications.h"
#import "Database.h"
#import "YBPlayer.h"
#import "YBTaskInstance.h"

@interface AllTasksViewController ()
{
    NSArray *_tasks;
    UITableViewExtension *_extension;
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
        if (!_extension) {
            _extension = [[UITableViewExtension alloc] initWithTableView:self.tableView];
            [_extension registerExtraCellClass:UITableViewCell.class withReuseIdentifier:@"HeadCell" forSection:0 direction:UITableViewExtension_ExtraCellDirection_Head];
        }
        NSNumber *height = [NSNumber numberWithFloat:44];
        [_extension setExtraCellHeight:height forSection:0 direction:UITableViewExtension_ExtraCellDirection_Head withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        [_extension setExtraCellHeight:nil forSection:0 direction:UITableViewExtension_ExtraCellDirection_Head withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_extension) {
        return _tasks.count + [_extension numberOfRowsInSection:section];
    }
    
    return _tasks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_extension) {
        NSNumber *height = [_extension heightForRowAtIndexPath:indexPath];
        if (height) {
            return height.floatValue;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_extension) {
        UITableViewCell *cell = [_extension cellForRowAtIndexPath:&indexPath];
        if (cell) {
            cell.textLabel.text = @"+ Add New Task";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.9];
            return cell;
        }
    }
    
    static NSString *CellIdentifier = @"Cell";
    AllTasksViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    YBTaskInstance *task = _tasks[indexPath.row];
    cell.title.text = task.title;
    cell.value.text = [NSString stringWithFormat:@"%d", (int)task.value.integerValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_extension isExtraCellForDirection:UITableViewExtension_ExtraCellDirection_Head withIndexPath:indexPath]) {
        TaskEditingViewController *viewController = TaskEditingViewController.viewController;
        // TODO
        // ...
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end

@implementation AllTasksViewCell

@end
