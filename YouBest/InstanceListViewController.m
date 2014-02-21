//
//  InstanceListViewController.m
//  YouBest
//
//  Created by Jason Yang on 14-2-20.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "InstanceListViewController.h"
#import "PlayerTabBarController.h"
#import "Database.h"
#import "YBPlayer.h"
#import "YBItemInstance.h"

@interface InstanceListViewController ()
{
    NSArray *_instances;
}
@end

@implementation InstanceListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    InstanceListViewTabBarItem *tabBarItem = (InstanceListViewTabBarItem *)self.tabBarItem;
    if ([tabBarItem isKindOfClass:InstanceListViewTabBarItem.class]) {
        self.type = tabBarItem.type;
    }
    
    [self updateDataSourceDown];
}

#pragma mark public

- (void)updateDataSourceDown
{
    PlayerTabBarController *controller = (PlayerTabBarController *)self.parentViewController;
    NSParameterAssert([controller isKindOfClass:PlayerTabBarController.class]);
    if (![controller isKindOfClass:PlayerTabBarController.class]) {
        _instances = nil;
        return;
    }
    
    YBPlayer *player = controller.player;
    NSParameterAssert(player);
    if (!player) {
        _instances = nil;
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    Database *db = Database.sharedDatabase;
    [db.context performBlockAndWait:^{
        NSArray *mos = [db fetchAllItemInstancesForPlayerID:player.identity withType:self.type];
        for (MOItemInstance *mo in mos) {
            YBItemInstance *inst = [[YBItemInstance alloc] initWithMO:mo];
            if (inst) {
                [array addObject:inst];
            }
        }
    }];
    
    dispatch_block_t block = ^{
        _instances = array;
    };
    
    if (NSThread.isMainThread) {
        block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _instances.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    InstanceListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    YBItemInstance *inst = _instances[indexPath.row];
    cell.title.text = inst.name;
    NSNumber *value = inst.value;
    if (value) {
        cell.value.text = [NSString stringWithFormat:@"%d", (int)inst.value.integerValue];
    }
    else {
        cell.coin.hidden = YES;
        cell.value.text = inst.content;
        cell.value.textColor = [UIColor grayColor];
    }
    
    return cell;
}

@end

@implementation InstanceListViewCell

@end

@implementation InstanceListViewTabBarItem

@end
