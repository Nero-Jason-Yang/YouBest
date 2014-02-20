//
//  YBItemInstance.m
//  YouBest
//
//  Created by Jason Yang on 14-2-19.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "YBItemInstance.h"
#import "MOItemInstance.h"

@implementation YBItemInstance

- (id)initWithMO:(MOItemInstance *)mo
{
    if (self = [super init]) {
        _mo = mo;
        if (mo) {
            _playerID = mo.playerID;
            _type = mo.type.shortValue;
        }
        [self updateDown];
    }
    return self;
}

- (void)updateDown
{
    MOItemInstance *mo = self.mo;
    if (mo) {
        _name = mo.name;
        _content = mo.content;
        _value = mo.value;
        _state = mo.state.shortValue;
        _total = mo.total;
        _number = mo.number;
        _creationDate = mo.creationDate;
        _expiryDate = mo.expiryDate;
        _startDate = mo.startDate;
        _finishDate = mo.finishDate;
    }
}

- (void)updateUp
{
    MOItemInstance *mo = self.mo;
    if (mo) {
        mo.name = _name;
        mo.content = _content;;
        mo.value = [NSNumber numberWithInteger:_value];
        mo.state = [NSNumber numberWithShort:_state];
        mo.total = _total;
        mo.number = _number;
        mo.creationDate = _creationDate;
        mo.expiryDate = _expiryDate;
        mo.startDate = _startDate;
        mo.finishDate = _finishDate;
    }
}

@end
