//
//  AppDelegate.h
//  YouBest
//
//  Created by Jason Yang on 14-1-14.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBPlayer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)sharedAppDelegate;

@property (nonatomic) UIWindow *window;

@property BOOL adminMode;
@property (nonatomic) YBPlayer *currentPlayer;

@end
