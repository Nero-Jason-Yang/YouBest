//
//  WishesViewController.m
//  YouBest
//
//  Created by Yang Jason on 14-2-9.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "WishesViewController.h"
#import "UITableViewController+Utils.h"
#import "TabsViewController.h"
#import "Database.h"
#import "YBPlayer.h"
#import "YBItemInstance.h"

@interface WishesViewController ()
{
    NSArray *_wishes;
}
@end

@implementation WishesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateDataSourceDown];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self correctTableViewPosition];
    
    [super viewWillAppear:animated];
}

#pragma mark public

- (void)updateDataSourceDown
{
    TabsViewController *tabsViewController = (TabsViewController *)self.parentViewController;
    NSParameterAssert([tabsViewController isKindOfClass:TabsViewController.class]);
    if (![tabsViewController isKindOfClass:TabsViewController.class]) {
        _wishes = nil;
        return;
    }
    
    YBPlayer *player = tabsViewController.player;
    NSParameterAssert(player);
    if (!player) {
        _wishes = nil;
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    Database *db = Database.sharedDatabase;
    [db.context performBlockAndWait:^{
        NSArray *mos = [db fetchAllItemInstancesForPlayer:player.mo withType:YBItemType_Wish];
        for (MOItemInstance *mo in mos) {
            YBItemInstance *wish = [[YBItemInstance alloc] initWithMO:mo];
            [array addObject:wish];
        }
    }];
    
    dispatch_block_t block = ^{
        _wishes = array;
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
    return _wishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    YBItemInstance *wish = _wishes[indexPath.row];
    cell.textLabel.text = wish.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
