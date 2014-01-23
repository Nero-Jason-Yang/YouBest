//
//  TaskMO.h
//  YouBest
//
//  Created by Yang Jason on 14-1-23.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JobMO, PlayerMO;

@interface TaskMO : NSManagedObject

@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) JobMO *job;
@property (nonatomic, retain) PlayerMO *player;

@end
