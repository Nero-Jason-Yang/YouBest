//
//  JobMO.h
//  YouBest
//
//  Created by Yang Jason on 14-1-23.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaskMO;

@interface JobMO : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * reward;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface JobMO (CoreDataGeneratedAccessors)

- (void)addTasksObject:(TaskMO *)value;
- (void)removeTasksObject:(TaskMO *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
