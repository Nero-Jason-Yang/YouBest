//
//  MOOption.h
//  YouBest
//
//  Created by Jason Yang on 14-2-19.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MOOption : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;

@end
