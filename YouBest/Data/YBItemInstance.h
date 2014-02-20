//
//  YBItemInstance.h
//  YouBest
//
//  Created by Jason Yang on 14-2-19.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBTypedef.h"

@class MOItemInstance;

@interface YBItemInstance : NSObject
- (id)initWithMO:(MOItemInstance *)mo;
@property (nonatomic,readonly) MOItemInstance *mo;
@property (nonatomic,readonly) NSString *playerID;
@property (nonatomic,readonly) YBItemType type;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *content;
@property (nonatomic) NSNumber *value;
@property (nonatomic) YBItemState state;
@property (nonatomic) NSNumber *total;
@property (nonatomic) NSNumber *number;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSDate *expiryDate;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *finishDate;
- (void)updateDown;
- (void)updateUp;
@end
