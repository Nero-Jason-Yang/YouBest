//
//  MOItemRecord.h
//  YouBest
//
//  Created by Jason Yang on 14-2-18.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MOItemRecord : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * playerID;
@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * value;

@end
