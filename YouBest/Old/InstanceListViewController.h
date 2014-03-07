//
//  InstanceListViewController.h
//  YouBest
//
//  Created by Jason Yang on 14-2-20.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBTypedef.h"

@interface InstanceListViewController : UITableViewController
@property (nonatomic) YBItemType type;
@end

@interface InstanceListViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *coin;
@property (strong, nonatomic) IBOutlet UILabel *value;
@end

@interface InstanceListViewTabBarItem : UITabBarItem
@property (nonatomic) YBItemType type;
@end
