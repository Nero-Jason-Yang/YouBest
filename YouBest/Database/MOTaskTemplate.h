//
//  MOTaskTemplate.h
//  YouBest
//
//  Created by Jason Yang on 14-4-1.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MOTaskTemplate : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * identity;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * difficulty;

@end
