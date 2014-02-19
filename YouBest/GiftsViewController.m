//
//  GiftsViewController.m
//  YouBest
//
//  Created by Yang Jason on 14-1-21.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "GiftsViewController.h"
#import "TabsViewController.h"
#import "Database.h"
#import "YBPlayer.h"
#import "YBItemInstance.h"

@interface GiftsViewController ()
{
    NSArray *_gifts;
}
@end

@implementation GiftsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateDataSourceDown];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.navigationItem) {
        UIView *view = self.tableView;
        UIView *superview = view.superview;
        CGPoint point = [superview convertPoint:CGPointZero fromView:view];
        CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
        CGFloat height = navigationBarFrame.origin.y + navigationBarFrame.size.height;
        if (point.y < height) {
            point.y = height;
            CGRect frame = view.frame;
            frame.origin = point;
            view.frame = frame;
        }
    }
}

#pragma mark public

- (void)updateDataSourceDown
{
    TabsViewController *tabsViewController = (TabsViewController *)self.parentViewController;
    NSParameterAssert([tabsViewController isKindOfClass:TabsViewController.class]);
    if (![tabsViewController isKindOfClass:TabsViewController.class]) {
        _gifts = nil;
        return;
    }
    
    YBPlayer *player = tabsViewController.player;
    NSParameterAssert(player);
    if (!player) {
        _gifts = nil;
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    Database *db = Database.sharedDatabase;
    [db.context performBlockAndWait:^{
        NSArray *mos = [db fetchAllItemInstancesForPlayer:player.mo withType:YBItemType_Gift];
        for (MOItemInstance *mo in mos) {
            YBItemInstance *gift = [[YBItemInstance alloc] initWithMO:mo];
            [array addObject:gift];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    YBItemInstance *gift = _gifts[indexPath.row];
    cell.textLabel.text = gift.name;
    
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
