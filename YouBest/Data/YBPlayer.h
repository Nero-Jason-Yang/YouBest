//
//  YBPlayer.h
//  YouBest
//
//  Created by Jason Yang on 14-2-19.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOPlayer;

@interface YBPlayer : NSObject
- (id)initWithMO:(MOPlayer *)mo;
@property (nonatomic,readonly) MOPlayer *mo;
@property (nonatomic,readonly) NSString *identity;
@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *birthday;
@property (nonatomic) NSInteger value;
- (void)updateDown;
- (void)updateUp;
@end
