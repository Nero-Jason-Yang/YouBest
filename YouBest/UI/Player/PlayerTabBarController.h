//
//  PlayerTabBarController.h
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBPlayer;

@interface PlayerTabBarController : UITabBarController
@property (nonatomic) YBPlayer *player;
@end

@interface UIViewController (PlayerTabBarController)
@property (readonly) PlayerTabBarController *playerTabBarController;
@end

@interface UITableViewController (AddButton)
- (void)setupAddButton;
@end
