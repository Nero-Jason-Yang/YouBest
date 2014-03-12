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
#import "Database.h"
#import "YBPlayer.h"
#import "YBTaskInstance.h"

@interface AllTasksViewController ()
{
    NSArray *_tasks;
}
@end

@implementation AllTasksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"任务", @"Task");
    
    [self setupAddButton];
    
    [self updateDataSourceDown];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    ButtonDockedTableView *tableView = (ButtonDockedTableView *)self.tableView;
    tableView.tableFooterButtonTitle = @"+ task";
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

#pragma mark - Table view data source

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

@end

@implementation AllTasksViewCell

@end
