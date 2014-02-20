//
//  MOItemInstance.h
//  YouBest
//
//  Created by Jason Yang on 14-2-20.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MOItemInstance : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * expiryDate;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * itemTemplate;
@property (nonatomic, retain) NSString * playerID;

@end
