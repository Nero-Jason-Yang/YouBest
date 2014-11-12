//
//  TaskInfo.h
//  YouBest
//
//  Created by Jason Yang on 14/11/12.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaskData;

@interface TaskInfo : NSObject

@property (nonatomic) NSString * title;
@property (nonatomic) NSString * subtitle;
@property (nonatomic) NSString * icon;
@property (nonatomic) NSNumber * worth;
@property (nonatomic) NSString * symbol;
@property (nonatomic) NSDate * creationDate;

- (id)initWithData:(TaskData *)data;

@end
