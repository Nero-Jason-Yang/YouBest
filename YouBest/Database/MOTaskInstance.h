//
//  MOTaskInstance.h
//  YouBest
//
//  Created by Jason Yang on 14-4-1.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MOTaskInstance : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * expiryDate;
@property (nonatomic, retain) NSDate * finishedDate;
@property (nonatomic, retain) NSString * playerID;
@property (nonatomic, retain) NSString * templateID;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * difficulty;

@end
