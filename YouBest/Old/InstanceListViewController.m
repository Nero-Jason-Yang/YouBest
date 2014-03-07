//
//  InstanceListViewController.m
//  YouBest
//
//  Created by Jason Yang on 14-2-20.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "InstanceListViewController.h"
#import "AppDelegate.h"
#import "PlayerTabsViewController.h"
#import "Database.h"
#import "YBPlayer.h"
#import "YBItemInstance.h"

#define AddButton_BackgroundColor_Normal   [UIColor colorWithWhite:0.95 alpha:0.9]
#define AddButton_BackgroundColor_Selected [UIColor colorWithWhite:0.85 alpha:1.0]

@interface InstanceListViewController ()
{
    NSArray *_instances;
    UIButton *_addButton;
    UIView *_footerView;
}
@end

@implementation InstanceListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    InstanceListViewTabBarItem *tabBarItem = (InstanceListViewTabBarItem *)self.tabBarItem;
    NSParameterAssert([tabBarItem isKindOfClass:InstanceListViewTabBarItem.class]);
    if ([tabBarItem isKindOfClass:InstanceListViewTabBarItem.class]) {
        self.type = tabBarItem.type;
        self.title = tabBarItem.title;
    }
    
    [self setupAddButton];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [self updateDataSourceDown];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdminModeChanged:) name:AdminModeChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateUIForAdminMode:self.adminMode];
}

#pragma mark public

- (void)updateDataSourceDown
{
    PlayerTabsViewController *controller = (PlayerTabsViewController *)self.parentViewController;
    NSParameterAssert([controller isKindOfClass:PlayerTabsViewController.class]);
    if (![controller isKindOfClass:PlayerTabsViewController.class]) {
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

#pragma mark internal

- (BOOL)adminMode
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    return app.adminMode;
}

- (void)setupAddButton
{
    NSString *buttonTitle;
    switch (self.type) {
        case YBItemType_Task:
            buttonTitle = @"+ 添加任务";
            break;
            
        case YBItemType_Gift:
            buttonTitle = @"+ 添加礼物";
            break;
            
        default:
            buttonTitle = nil;
            break;
    }
    
    if (buttonTitle) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        [btn setTitle:buttonTitle forState:UIControlStateNormal];
        btn.backgroundColor = AddButton_BackgroundColor_Normal;
        [btn addTarget:self action:@selector(onAddButtonDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(onAddButtonUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(onAddButtonUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        
        _addButton = btn;
        _footerView = [[UIView alloc] initWithFrame:btn.frame];
    }
}

- (void)onAddButtonDown:(id)sender
{
    UIButton *button = sender;
    button.backgroundColor = AddButton_BackgroundColor_Selected;
}

- (void)onAddButtonUpInside:(id)sender
{
    UIButton *button = sender;
    button.backgroundColor = AddButton_BackgroundColor_Normal;
}

- (void)onAddButtonUpOutside:(id)sender
{
    UIButton *button = sender;
    button.backgroundColor = AddButton_BackgroundColor_Normal;
}

- (void)onAdminModeChanged:(id)sender
{
    NSNotification *notification = sender;
    NSNumber *number = notification.object;
    [self updateUIForAdminMode:number.boolValue];
    
    if (_addButton) {
        // animation for addButton join.
        _addButton.alpha = 0.0;
        [UIView animateWithDuration:0.15 delay:0.2 options:0 animations:^{
            _addButton.alpha = 1.0;
        } completion:nil];
    }
}

#pragma mark update UI

- (void)updateUIForAdminMode:(BOOL)adminMode
{
    if (_addButton) {
        if (adminMode) {
            CGRect frame = _addButton.frame;
            frame.origin = CGPointMake(0, self.view.frame.size.height - frame.size.height);
            _addButton.frame = frame;
            _addButton.alpha = 1.0;
            if (!_addButton.superview) {
                [self.view.superview addSubview:_addButton];
            }
            if (!self.tableView.tableFooterView) {
                self.tableView.tableFooterView = _footerView;
            }
        }
        else {
            if (_addButton.superview) {
                [_addButton removeFromSuperview];
            }
            if (self.tableView.tableFooterView) {
                self.tableView.tableFooterView = nil;
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

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.adminMode) {
        if (indexPath.row + 1 >= _instances.count) {
            // TODO
        }
    }
}

@end

@implementation InstanceListViewCell

@end

@implementation InstanceListViewTabBarItem

- (void)setType:(YBItemType)type
{
    switch (type) {
        case YBItemType_Task:
            self.image = [UIImage imageNamed:@"task_24.png"];
            break;
            
        case YBItemType_Gift:
            self.image = [UIImage imageNamed:@"gift_24.png"];
            break;
            
        case YBItemType_Wish:
            self.image = [UIImage imageNamed:@"strawberry_24.png"];
            break;
            
        default:
            break;
    }
    _type = type;
}

@end
