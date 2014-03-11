//
//  YBTaskInstance.m
//  YouBest
//
//  Created by Jason Yang on 14-3-11.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "YBTaskInstance.h"
#import "MOTaskInstance.h"

@implementation YBTaskInstance

- (id)initWithMO:(MOTaskInstance *)mo
{
    if (self = [super init]) {
        _mo = mo;
        if (mo) {
            _playerID = mo.playerID;
            _templateID = mo.templateID;
        }
        [self updateDown];
    }
    return self;
}

- (void)updateDown
{
    MOTaskInstance *mo = self.mo;
    if (mo) {
        _title = mo.title;
        _content = mo.content;
        _value = mo.value;
        _creationDate = mo.creationDate;
        _finishedDate = mo.finishedDate;
        _expiryDate = mo.expiryDate;
    }
}

- (void)updateUp
{
    MOTaskInstance *mo = self.mo;
    if (mo) {
        mo.title = _title;
        mo.content = _content;
        mo.value = _value;
        mo.creationDate = _creationDate;
        mo.finishedDate = _finishedDate;
        mo.expiryDate = _expiryDate;
    }
}

@end
