//
//  GiftInfo.m
//  YouBest
//
//  Created by Jason Yang on 14/11/12.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "GiftInfo.h"
#import "GiftData.h"

@implementation GiftInfo

- (id)initWithData:(GiftData *)data {
    if (self = [super init]) {
        if (data) {
            self.icon = data.icon;
            self.title = data.title;
            self.subtitle = data.subtitle;
            self.worth = data.worth;
            self.symbol = data.symbol;
            self.creationDate = data.creationDate;
        }
    }
    return self;
}

- (void)fillToData:(GiftData *)data {
    NSParameterAssert(data);
    data.icon = self.icon;
    data.title = self.title;
    data.subtitle = self.subtitle;
    data.worth = self.worth;
    data.symbol = self.symbol;
    data.creationDate = self.creationDate;
}

@end
