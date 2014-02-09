//
//  MOTemplate.h
//  YouBest
//
//  Created by Yang Jason on 14-2-9.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOItem;

@interface MOTemplate : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * identity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) MOItem *items;

@end
