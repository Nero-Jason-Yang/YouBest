//
//  MOTaskTemplate.h
//  YouBest
//
//  Created by Jason Yang on 14-3-11.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MOTaskTemplate : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * identity;

@end
