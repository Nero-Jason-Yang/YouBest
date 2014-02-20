//
//  Database.h
//  YouBest
//
//  Created by Jason Yang on 14-2-19.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBTypedef.h"
#import "NSManagedObjectContext+Utils.h"
#import "MOOption.h"
#import "MOPlayer.h"
#import "MOItemTemplate.h"
#import "MOItemInstance.h"
#import "MOItemRecord.h"

#define Entity_Option       @"Option"
#define Entity_Player       @"Player"
#define Entity_ItemTemplate @"ItemTemplate"
#define Entity_ItemInstance @"ItemInstance"
#define Entity_ItemRecord   @"ItemRecord"

@interface Database : NSObject

+ (Database *)sharedDatabase;

@property (nonatomic,readonly) NSManagedObjectContext *context;

- (void)save;

- (NSArray *)fetchAllPlayers;
- (NSArray *)fetchAllItemInstancesForPlayerID:(NSString *)playerID withType:(YBItemType)type;

@end
