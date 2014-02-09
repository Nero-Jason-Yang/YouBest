//
//  MOItem.h
//  YouBest
//
//  Created by Yang Jason on 14-2-9.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOPlayer, MOTemplate;

@interface MOItem : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * expiryDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) MOTemplate *template;
@property (nonatomic, retain) MOPlayer *player;

@end
