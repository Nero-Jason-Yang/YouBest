//
//  Database.m
//  YouBest
//
//  Created by Jason Yang on 14/11/12.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "Database.h"
#import "NSManagedObjectContext+Utils.h"
#import "TaskData.h"
#import "GiftData.h"

#define EntityName_Task @"Task"
#define EntityName_Gift @"Gift"

#define EntityProp_CreationDate @"creationDate"

@interface Database ()
@property (nonatomic) NSManagedObjectContext *context;
@end

@implementation Database

+ (Database *)sharedDatabase {
    static Database *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[Database alloc] init];
    });
    return db;
}

- (id)init {
    if (self = [super init]) {
        self.context = [NSManagedObjectContext contextWithModelName:@"Main"];
        [self addTestingDataSet];
    }
    return self;
}

- (void)addTestingDataSet {
    [self.context performBlockAndWait:^{
        if (0 == [self.context fetchCountForEntityName:EntityName_Task withPredicate:nil]) {
            TaskData *data = [self.context createObjectForEntityName:EntityName_Task];
            data.title = @"Clean The Room";
            data.subtitle = @"Mmmmmmmm, Mmmmmmm.";
            data.worth = @(3);
            data.creationDate = [NSDate date];
            
            data = [self.context createObjectForEntityName:EntityName_Task];
            data.title = @"Make Your Bed";
            data.subtitle = @"Zzzzzzz.";
            data.worth = @(2);
            data.creationDate = [NSDate date];
            
            data = [self.context createObjectForEntityName:EntityName_Task];
            data.title = @"Finish Your Homework";
            data.subtitle = @"Inside one hour.";
            data.worth = @(1);
            data.creationDate = [NSDate date];
        }
        
        if (0 == [self.context fetchCountForEntityName:EntityName_Gift withPredicate:nil]) {
            GiftData *data = [self.context createObjectForEntityName:EntityName_Gift];
            data.title = @"TV time half hour";
            data.subtitle = @"please keep your time";
            data.worth = @(10);
            data.creationDate = [NSDate date];
            
            data = [self.context createObjectForEntityName:EntityName_Gift];
            data.title = @"TV time one hour";
            data.subtitle = @"";
            data.worth = @(20);
            data.creationDate = [NSDate date];
            
            data = [self.context createObjectForEntityName:EntityName_Gift];
            data.title = @"Watch a movie";
            data.subtitle = @"";
            data.worth = @(100);
            data.creationDate = [NSDate date];
            
            data = [self.context createObjectForEntityName:EntityName_Gift];
            data.title = @"Play the flight chess";
            data.subtitle = @"";
            data.worth = @(20);
            data.creationDate = [NSDate date];
            
            data = [self.context createObjectForEntityName:EntityName_Gift];
            data.title = @"Make a paper star";
            data.subtitle = @"";
            data.worth = @(10);
            data.creationDate = [NSDate date];
            
            data = [self.context createObjectForEntityName:EntityName_Gift];
            data.title = @"Go outing";
            data.subtitle = @"Wooooooow";
            data.worth = @(40);
            data.creationDate = [NSDate date];
        }
        
        [self.context save];
    }];
}

- (NSSortDescriptor *)creationDateDesendingSorterDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:EntityProp_CreationDate ascending:NO];
}

- (NSArray *)allTasks {
    NSMutableArray *array = [NSMutableArray array];
    [self.context performBlockAndWait:^{
        NSArray *objects = [self.context fetchObjectsForEntityName:EntityName_Task withPredicate:nil sortDescriptors:@[self.creationDateDesendingSorterDescriptor]];
        for (id data in objects) {
            [array addObject:[[TaskInfo alloc] initWithData:data]];
        }
    }];
    return array;
}

- (NSArray *)allGifts {
    NSMutableArray *array = [NSMutableArray array];
    [self.context performBlockAndWait:^{
        NSArray *objects = [self.context fetchObjectsForEntityName:EntityName_Gift withPredicate:nil sortDescriptors:@[self.creationDateDesendingSorterDescriptor]];
        for (id data in objects) {
            [array addObject:[[GiftInfo alloc] initWithData:data]];
        }
    }];
    return array;
}

- (void)addTask:(TaskInfo *)task {
    [self.context performBlockAndWait:^{
        id data = [self.context createObjectForEntityName:EntityName_Task];
        NSParameterAssert(data);
        if (data) {
            [task fillToData:data];
        }
    }];
}

- (void)addGift:(GiftInfo *)gift {
    [self.context performBlockAndWait:^{
        id data = [self.context createObjectForEntityName:EntityName_Gift];
        NSParameterAssert(data);
        if (data) {
            [gift fillToData:data];
        }
    }];
}

- (void)removeTask:(TaskInfo *)task {
    
}

- (void)removeGift:(GiftInfo *)gift {
    
}

@end
