//
//  MORecord.h
//  YouBest
//
//  Created by Yang Jason on 14-2-9.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MORecord : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSString * playerID;
@property (nonatomic, retain) NSString * templateID;

@end
