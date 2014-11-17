//
//  Database.h
//  YouBest
//
//  Created by Jason Yang on 14/11/12.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskInfo.h"
#import "GiftInfo.h"

@interface Database : NSObject

+ (Database *)sharedDatabase;

- (NSArray *)allTasks; // fetch all tasks with typeof TaskInfo.
- (NSArray *)allGifts; // fetch all gifts with typeof GiftInfo.

- (void)addTask:(TaskInfo *)task;
- (void)addGift:(GiftInfo *)gift;

- (void)removeTask:(TaskInfo *)task;
- (void)removeGift:(GiftInfo *)gift;

@end
