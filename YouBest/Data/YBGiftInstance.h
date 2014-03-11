//
//  YBGiftInstance.h
//  YouBest
//
//  Created by Jason Yang on 14-3-11.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOGiftInstance;

@interface YBGiftInstance : NSObject
- (id)initWithMO:(MOGiftInstance *)mo;
@property (nonatomic,readonly) MOGiftInstance *mo;
@property (nonatomic,readonly) NSString *playerID;
@property (nonatomic,readonly) NSString *templateID;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;
@property (nonatomic) NSNumber *value;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSDate *finishedDate;
@property (nonatomic) NSDate *expiryDate;
- (void)updateDown;
- (void)updateUp;
@end
