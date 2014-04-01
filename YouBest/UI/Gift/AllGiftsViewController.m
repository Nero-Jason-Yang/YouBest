//
//  AllGiftsViewController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "AllGiftsViewController.h"
#import "PlayerTabBarController.h"
#import "UIButton+UITableView.h"
#import "AppDelegate.h"
#import "Notifications.h"
#import "Database.h"
#import "YBPlayer.h"
#import "YBGiftInstance.h"

@interface AllGiftsViewController ()
{
    NSArray *_gifts;
    UIButton *_headerButton;
}
@end

@implementation AllGiftsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"礼物", @"Gift");
    _headerButton = [UIButton tableViewHeaderButtonWithTitle:@"+ Add New Gift" action:@selector(onActionAddNewGift:) target:self];
    
    [self updateDataSourceDown];
    
    [self didChangeAdminMode:((AppDelegate *)(UIApplication.sharedApplication.delegate)).adminMode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyAdminModeChanged:) name:AdminModeChangedNotification object:nil];
}

#pragma mark public

- (void)updateDataSourceDown
{
    YBPlayer *player = AppDelegate.sharedAppDelegate.currentPlayer;
    NSParameterAssert(player);
    if (!player) {
        _gifts = nil;
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    Database *db = Database.sharedDatabase;
    [db.context performBlockAndWait:^{
        NSArray *mos = [db fetchAllGiftInstancesForPlayerID:player.identity];
        for (MOGiftInstance *mo in mos) {
            YBGiftInstance *gift = [[YBGiftInstance alloc] initWithMO:mo];
            if (gift) {
                [array addObject:gift];
            }
        }
    }];
    
    dispatch_block_t block = ^{
        _gifts = array;
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

- (void)onActionAddNewGift:(id)sender
{
    UIButton *btn = sender;
    NBLog(@"on press button: %@", [btn titleForState:UIControlStateNormal]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _gifts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AllGiftsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    YBGiftInstance *gift = _gifts[indexPath.row];
    cell.title.text = gift.title;
    cell.value.text = [NSString stringWithFormat:@"%d", (int)gift.value.integerValue];
    
    return cell;
}

@end

@implementation AllGiftsViewCell

@end
