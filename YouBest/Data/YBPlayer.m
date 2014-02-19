//
//  YBPlayer.m
//  YouBest
//
//  Created by Jason Yang on 14-2-19.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "YBPlayer.h"
#import "Database.h"

@implementation YBPlayer

- (id)initWithMO:(MOPlayer *)mo
{
    if (self = [super init]) {
        _mo = mo;
        if (mo) {
            _identity = mo.identity;
        }
        [self updateDown];
    }
    return self;
}

- (void)updateDown
{
    MOPlayer *mo = self.mo;
    if (mo) {
        _name = mo.name;
        _birthday = mo.birthday;
        _value = mo.value.integerValue;
    }
}

- (void)updateUp
{
    MOPlayer *mo = self.mo;
    if (mo) {
        mo.name = _name;
        mo.birthday = _birthday;
        mo.value = [NSNumber numberWithInteger:_value];
    }
}

@end
