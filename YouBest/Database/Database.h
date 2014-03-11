//
//  Database.h
//  YouBest
//
//  Created by Jason Yang on 14-2-19.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSManagedObjectContext+Utils.h"
#import "MOOption.h"
#import "MOPlayer.h"
#import "MOTaskTemplate.h"
#import "MOTaskInstance.h"
#import "MOTaskRecord.h"
#import "MOGiftTemplate.h"
#import "MOGiftInstance.h"
#import "MOGiftRecord.h"

#define Entity_Option       @"Option"
#define Entity_Player       @"Player"
#define Entity_TaskTemplate @"TaskTemplate"
#define Entity_TaskInstance @"TaskInstance"
#define Entity_TaskRecord   @"TaskRecord"
#define Entity_GiftTemplate @"GiftTemplate"
#define Entity_GiftInstance @"GiftInstance"
#define Entity_GiftRecord   @"GiftRecord"

@interface Database : NSObject

+ (Database *)sharedDatabase;

@property (nonatomic,readonly) NSManagedObjectContext *context;

- (void)save;

- (NSArray *)fetchAllPlayers;
- (NSArray *)fetchAllTaskTemplatesForPlayerID:(NSString *)playerID;
- (NSArray *)fetchAllTaskInstancesForPlayerID:(NSString *)playerID;
- (NSArray *)fetchAllGiftTemplatesForPlayerID:(NSString *)playerID;
- (NSArray *)fetchAllGiftInstancesForPlayerID:(NSString *)playerID;

@end
