//
//  Database.m
//  YouBest
//
//  Created by Jason Yang on 14-2-19.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "Database.h"

#define KEY_Entity_Option_AdminPassword @"adminPassword"

@implementation Database

+ (Database *)sharedDatabase
{
    static Database *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[Database alloc] init];
    });
    return db;
}

- (id)init
{
    if (self = [super init]) {
        _context = [self load];
    }
    return self;
}

- (NSManagedObjectContext *)load
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextWithModelName:@"YouBest"];
    if (!context) {
        return nil;
    }
    
    @autoreleasepool {
        if (0 == [context fetchCountForEntityName:Entity_Option withPredicate:nil]) {
            MOOption *option = [context createObjectForEntityName:Entity_Option];
            option.name = KEY_Entity_Option_AdminPassword;
            option.value = @"1234";
            
            // make a default player
            MOPlayer *player = [context createObjectForEntityName:Entity_Player];
            player.identity = [[NSUUID UUID] UUIDString];
            player.name = @"宝贝";
            player.birthday = NSDate.date;
            player.value = [NSNumber numberWithInteger:0];
            
            MOTaskTemplate *temp = [context createObjectForEntityName:Entity_TaskTemplate];
            temp.identity = [[NSUUID UUID] UUIDString];
            temp.title = @"叠被子";
            temp.content = @"收拾好自己睡觉的床，叠好被子，整理床单";
            temp.value = [NSNumber numberWithInteger:1];
            
            {
                MOTaskInstance *inst = [context createObjectForEntityName:Entity_TaskInstance];
                inst.playerID = player.identity;
                inst.templateID = temp.identity;
                inst.title = temp.title;
                inst.content = temp.content;
                inst.value = temp.value;
                inst.creationDate = NSDate.date;
                inst.finishedDate = nil;
                inst.expiryDate = nil;
            }
            
            {
                MOTaskInstance *inst = [context createObjectForEntityName:Entity_TaskInstance];
                inst.playerID = player.identity;
                inst.templateID = nil;
                inst.title = @"喝杯开水";
                inst.content = @"多喝开水有益健康";
                inst.value = [NSNumber numberWithInteger:1];
                inst.creationDate = NSDate.date;
                inst.finishedDate = nil;
                inst.expiryDate = [NSDate dateWithTimeIntervalSinceNow:30*24*60*60]; // one month limit
            }
            
            for (int i = 0; i < 10; i ++) {
                MOTaskInstance *inst = [context createObjectForEntityName:Entity_TaskInstance];
                inst.playerID = player.identity;
                inst.templateID = nil;
                inst.title = [NSString stringWithFormat:@"Sample[%d]", i];
                inst.content = @"...";
                inst.value = [NSNumber numberWithInteger:1];
                inst.creationDate = NSDate.date;
                inst.finishedDate = nil;
                inst.expiryDate = nil;
            }
            
            {
                MOGiftInstance *inst = [context createObjectForEntityName:Entity_GiftInstance];
                inst.playerID = player.identity;
                inst.templateID = nil;
                inst.title = @"滑板车";
                inst.content = @"森宝迪滑板车三轮粉色公主";
                inst.value = [NSNumber numberWithInteger:30];
                inst.creationDate = NSDate.date;
                inst.finishedDate = nil;
                inst.expiryDate = nil;
            }
        }
    }
    
    [context save];
    return context;
}

- (void)save
{
    return [self.context save];
}

- (NSArray *)fetchAllPlayers
{
    return [self.context fetchObjectsForEntityName:Entity_Player];
}

- (NSArray *)fetchAllTaskTemplatesForPlayerID:(NSString *)playerID
{
    if (!playerID) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"playerID == %@", playerID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    return [self.context fetchObjectsForEntityName:Entity_TaskTemplate withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

- (NSArray *)fetchAllTaskInstancesForPlayerID:(NSString *)playerID
{
    if (!playerID) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"playerID == %@", playerID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    return [self.context fetchObjectsForEntityName:Entity_TaskInstance withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

- (NSArray *)fetchAllGiftTemplatesForPlayerID:(NSString *)playerID
{
    if (!playerID) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"playerID == %@", playerID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    return [self.context fetchObjectsForEntityName:Entity_GiftTemplate withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

- (NSArray *)fetchAllGiftInstancesForPlayerID:(NSString *)playerID
{
    if (!playerID) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"playerID == %@", playerID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO];
    return [self.context fetchObjectsForEntityName:Entity_GiftInstance withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

@end
