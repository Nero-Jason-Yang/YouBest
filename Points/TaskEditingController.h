//
//  TaskEditingController.h
//  Points
//
//  Created by Jason Yang on 14/11/21.
//  Copyright (c) 2014年 me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDImageButton.h"

@class TaskInfo;
@class TaskEditingController;

@protocol TaskEditingDelegate <NSObject>
- (void)taskEditingController:(TaskEditingController *)controller didFinishTaskWithInfo:(TaskInfo *)info;
@end

@interface TaskEditingController : UITableViewController
@property (nonatomic) id<TaskEditingDelegate> delegate;
@end

@interface TaskEditingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet IDImageButton *icon;
@property (strong, nonatomic) IBOutlet IDImageButton *symbol;
@property (strong, nonatomic) IBOutlet UITextField *title;
@property (strong, nonatomic) IBOutlet UITextField *subtitle;
@property (strong, nonatomic) IBOutlet UITextField *worth;
@end
