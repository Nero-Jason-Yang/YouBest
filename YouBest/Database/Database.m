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
            
            MOItemTemplate *temp = [context createObjectForEntityName:Entity_ItemTemplate];
            temp.type = [NSNumber numberWithShort:YBItemType_Task];
            temp.name = @"叠被子";
            temp.content = @"收拾好自己睡觉的床，叠好被子，整理床单";
            temp.value = [NSNumber numberWithInteger:1];
            temp.remark = @"这里是备注，只有管理员可以读写";
            
            NSManagedObjectID *tempMOID = temp.objectID;
            if (tempMOID.isTemporaryID) {
                [context save];
            }
            
            {
                MOItemInstance *inst = [context createObjectForEntityName:Entity_ItemInstance];
                inst.player = player;
                inst.type = temp.type;
                inst.name = temp.name;
                inst.content = temp.content;
                inst.value = temp.value;
                inst.state = [NSNumber numberWithShort:YBItemState_Ready];
                inst.total = nil;
                inst.number = nil; // not support number, means total is one.
                inst.creationDate = NSDate.date;
                inst.expiryDate = nil;
                inst.startDate = nil;
                inst.finishDate = nil;
                inst.itemTemplate = tempMOID.URIRepresentation.absoluteString;
            }
            
            {
                MOItemInstance *inst = [context createObjectForEntityName:Entity_ItemInstance];
                inst.player = player;
                inst.type = [NSNumber numberWithShort:YBItemType_Task];
                inst.name = @"喝杯开水";
                inst.content = @"多喝开水有益健康";
                inst.value = [NSNumber numberWithInteger:1];
                inst.state = [NSNumber numberWithShort:YBItemState_Ready];
                inst.total = nil; // nil means unlimited
                inst.number = [NSNumber numberWithInteger:0]; // support number
                inst.creationDate = NSDate.date;
                inst.expiryDate = [NSDate dateWithTimeIntervalSinceNow:30*24*60*60]; // one month limit
            }
            
            {
                MOItemInstance *inst = [context createObjectForEntityName:Entity_ItemInstance];
                inst.player = player;
                inst.type = [NSNumber numberWithShort:YBItemType_Gift];
                inst.name = @"滑板车";
                inst.content = @"森宝迪滑板车三轮粉色公主";
                inst.value = [NSNumber numberWithInteger:30];
                inst.state = [NSNumber numberWithShort:YBItemState_Ready];
                inst.creationDate = NSDate.date;
            }
            
            {
                MOItemInstance *inst = [context createObjectForEntityName:Entity_ItemInstance];
                inst.player = player;
                inst.type = [NSNumber numberWithShort:YBItemType_Wish];
                inst.name = @"自行车";
                inst.content = @"迪卡龙少女自行车6-8岁";
                inst.value = [NSNumber numberWithInteger:50];
                inst.state = [NSNumber numberWithShort:YBItemState_Ready];
                inst.creationDate = NSDate.date;
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

- (NSArray *)fetchAllItemInstancesForPlayer:(MOPlayer *)player withType:(YBItemType)type
{
    if (!player) {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d && player.identity == %@", type, player.identity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
    return [self.context fetchObjectsForEntityName:Entity_ItemInstance withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

@end
