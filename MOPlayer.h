//
//  MOPlayer.h
//  YouBest
//
//  Created by Yang Jason on 14-2-9.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOItem;

@interface MOPlayer : NSManagedObject

@property (nonatomic, retain) NSString * identity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSSet *items;
@end

@interface MOPlayer (CoreDataGeneratedAccessors)

- (void)addItemsObject:(MOItem *)value;
- (void)removeItemsObject:(MOItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
