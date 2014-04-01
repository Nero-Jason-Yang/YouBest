//
//  AllPlayersViewController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "AllPlayersViewController.h"
#import "PlayerTabBarController.h"
#import "UIButton+UITableView.h"
#import "AppDelegate.h"
#import "Notifications.h"
#import "Database.h"
#import "YBPlayer.h"

@interface AllPlayersViewController ()
{
    NSArray *_players;
    UIButton *_headerButton;
}
@end

@implementation AllPlayersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"宝贝", @"YouBest");
    
    [self updateDataSourceDown];
    [self didChangeAdminMode:((AppDelegate *)(UIApplication.sharedApplication.delegate)).adminMode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyAdminModeChanged:) name:AdminModeChangedNotification object:nil];
    
    if (0 == _players.count) {
        // TODO
        // to admin setup view.
    }
    else if (1 == _players.count) {
        PlayerTabBarController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerTabBarController"];
        if ([viewController isKindOfClass:PlayerTabBarController.class]) {
            AppDelegate.sharedAppDelegate.currentPlayer = _players[0];
            [self.navigationController pushViewController:viewController animated:NO];
        }
    }
    
    _headerButton = [UIButton tableViewHeaderButtonWithTitle:@"+ Add New Player" action:@selector(onActionAddNewPlayer:) target:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPlayerTabBar"] && segue.sourceViewController == self) {
        PlayerTabBarController *viewController = segue.destinationViewController;
        if ([viewController isKindOfClass:PlayerTabBarController.class]) {
            viewController.navigationItem.leftBarButtonItem = nil;
        }
    }
}

#pragma mark public

- (void)updateDataSourceDown
{
    NSMutableArray *array = [NSMutableArray array];
    Database *db = Database.sharedDatabase;
    [db.context performBlockAndWait:^{
        NSArray *mos = [db fetchAllPlayers];
        for (MOPlayer *mo in mos) {
            YBPlayer *player = [[YBPlayer alloc] initWithMO:mo];
            [array addObject:player];
        }
    }];
    
    dispatch_block_t block = ^{
        _players = array;
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

- (void)onActionAddNewPlayer:(id)sender
{
    UIButton *btn = sender;
    NBLog(@"on press button: %@", [btn titleForState:UIControlStateNormal]);
}

#pragma mark actions

- (IBAction)onAdminModeChange:(id)sender
{
    AppDelegate *appDelegate = UIApplication.sharedApplication.delegate;
    appDelegate.adminMode = !appDelegate.adminMode;
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _players.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    YBPlayer *player = _players[indexPath.row];
    cell.textLabel.text = player.name;
    
    return cell;
}

#pragma mark <UITableViewDelegate>

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate.sharedAppDelegate.currentPlayer = indexPath ? _players[indexPath.row] : nil;
    return indexPath;
}

@end
