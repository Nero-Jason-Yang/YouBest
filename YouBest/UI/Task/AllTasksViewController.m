//
//  AllTasksViewController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "AllTasksViewController.h"
#import "PlayerTabBarController.h"
#import "UIButton+UITableView.h"
#import "TaskEditingViewController.h"
#import "AppDelegate.h"
#import "Notifications.h"
#import "Database.h"
#import "YBPlayer.h"
#import "YBTaskInstance.h"

@interface AllTasksViewController ()
{
    NSMutableArray *_tasks;
    UIButton *_headerButton;
}
@end

@implementation AllTasksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"任务", @"Task");
    _headerButton = [UIButton tableViewHeaderButtonWithTitle:@"+ Add New Task" action:@selector(onActionAddNewTask:) target:self];
    
    [self updateDataSourceDown];
    [self didChangeAdminMode:((AppDelegate *)(UIApplication.sharedApplication.delegate)).adminMode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyAdminModeChanged:) name:AdminModeChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyDatabaseChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
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
    YBPlayer *player = AppDelegate.sharedAppDelegate.currentPlayer;
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

- (void)onNotifyAdminModeChanged:(id)sender
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
        self.tableView.tableHeaderView = _headerButton;
    }
    else {
        self.tableView.tableHeaderView = nil;
    }
}

- (void)onActionAddNewTask:(id)sender
{
    TaskEditingViewController *viewController = TaskEditingViewController.viewController;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)onNotifyDatabaseChange:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    id insertedObjects = [userInfo objectForKey:NSInsertedObjectsKey];
    for (id mo in insertedObjects) {
        if ([mo isKindOfClass:MOTaskInstance.class]) {
            YBTaskInstance *task = [[YBTaskInstance alloc] initWithMO:mo];
            if (task) {
                [_tasks insertObject:task atIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }
        }
    }
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AllTasksViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    YBTaskInstance *task = _tasks[indexPath.row];
    cell.title.text = task.title;
    cell.value.text = [NSString stringWithFormat:@"%d", (int)task.value.integerValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO
}

@end

@implementation AllTasksViewCell

@end
