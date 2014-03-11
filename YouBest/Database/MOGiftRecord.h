//
//  MOGiftRecord.h
//  YouBest
//
//  Created by Jason Yang on 14-3-11.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MOGiftRecord : NSManagedObject

@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * finishedDate;
@property (nonatomic, retain) NSString * playerID;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSString * title;

@end
