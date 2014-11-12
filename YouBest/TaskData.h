//
//  TaskData.h
//  YouBest
//
//  Created by Jason Yang on 14/11/12.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaskData : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSNumber * worth;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSDate * creationDate;

@end
