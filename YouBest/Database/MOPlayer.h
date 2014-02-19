//
//  MOPlayer.h
//  YouBest
//
//  Created by Jason Yang on 14-2-18.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOItemInstance;

@interface MOPlayer : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * identity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSSet *itemInstances;
@end

@interface MOPlayer (CoreDataGeneratedAccessors)

- (void)addItemInstancesObject:(MOItemInstance *)value;
- (void)removeItemInstancesObject:(MOItemInstance *)value;
- (void)addItemInstances:(NSSet *)values;
- (void)removeItemInstances:(NSSet *)values;

@end
