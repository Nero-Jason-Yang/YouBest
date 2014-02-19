//
//  MOItemTemplate.h
//  YouBest
//
//  Created by Jason Yang on 14-2-18.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MOItemTemplate : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * value;

@end
