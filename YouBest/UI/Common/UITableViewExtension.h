//
//  UITableViewExtension.h
//  YouBest
//
//  Created by Jason Yang on 14-3-24.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UITableViewExtension_ExtraCellDirection_Head 0
#define UITableViewExtension_ExtraCellDirection_Tail 1

@interface UITableViewExtension : NSObject
- (id)initWithTableView:(UITableView *)tableView;

- (void)registerExtraCellClass:(Class)cellClass withReuseIdentifier:(NSString *)identifier forSection:(NSInteger)section direction:(NSInteger)direction;
- (void)setExtraCellHeight:(NSNumber *)height forSection:(NSInteger)section direction:(NSInteger)direction withRowAnimation:(UITableViewRowAnimation)animation;
- (NSNumber *)heightOfExtraCellForSection:(NSInteger)section direction:(NSInteger)direction;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSNumber *)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath **)indexPath;
- (BOOL)isExtraCellForDirection:(NSInteger)direction withIndexPath:(NSIndexPath *)indexPath;
@end
