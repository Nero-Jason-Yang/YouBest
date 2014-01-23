//
//  GoodsMO.h
//  YouBest
//
//  Created by Yang Jason on 14-1-23.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GiftMO;

@interface GoodsMO : NSManagedObject

@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSSet *gifts;
@end

@interface GoodsMO (CoreDataGeneratedAccessors)

- (void)addGiftsObject:(GiftMO *)value;
- (void)removeGiftsObject:(GiftMO *)value;
- (void)addGifts:(NSSet *)values;
- (void)removeGifts:(NSSet *)values;

@end
