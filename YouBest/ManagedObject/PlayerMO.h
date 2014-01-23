//
//  PlayerMO.h
//  YouBest
//
//  Created by Yang Jason on 14-1-23.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GiftMO, RecordMO, TaskMO;

@interface PlayerMO : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *gifts;
@property (nonatomic, retain) NSSet *records;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface PlayerMO (CoreDataGeneratedAccessors)

- (void)addGiftsObject:(GiftMO *)value;
- (void)removeGiftsObject:(GiftMO *)value;
- (void)addGifts:(NSSet *)values;
- (void)removeGifts:(NSSet *)values;

- (void)addRecordsObject:(RecordMO *)value;
- (void)removeRecordsObject:(RecordMO *)value;
- (void)addRecords:(NSSet *)values;
- (void)removeRecords:(NSSet *)values;

- (void)addTasksObject:(TaskMO *)value;
- (void)removeTasksObject:(TaskMO *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
