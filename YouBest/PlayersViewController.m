//
//  PlayersViewController.m
//  YouBest
//
//  Created by Yang Jason on 14-1-21.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "PlayersViewController.h"
#import "TabsViewController.h"
#import "Database.h"
#import "YBPlayer.h"

@interface PlayersViewController ()
{
    NSArray *_players;
    YBPlayer *_currentPlayer;
}
@end

@implementation PlayersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateDataSourceDown];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPlayerTabs"] && segue.sourceViewController == self) {
        TabsViewController *viewController = segue.destinationViewController;
        if ([viewController isKindOfClass:TabsViewController.class]) {
            viewController.player = _currentPlayer;
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
    static NSString *CellIdentifier = @"PlayerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    YBPlayer *player = _players[indexPath.row];
    cell.textLabel.text = player.name;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath) {
        _currentPlayer = _players[indexPath.row];
    }
    return indexPath;
}

@end
