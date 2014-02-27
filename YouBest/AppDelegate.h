//
//  AppDelegate.h
//  YouBest
//
//  Created by Jason Yang on 14-1-14.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AdminModeChangedNotification @"AdminModeChangedNotification"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly) BOOL adminMode;

@end
