//
//  RecordMO.h
//  YouBest
//
//  Created by Yang Jason on 14-1-23.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlayerMO;

@interface RecordMO : NSManagedObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * moid;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) PlayerMO *player;

@end
