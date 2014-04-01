//
//  TaskEditingViewController.h
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskEditingViewController : UIViewController
+ (id)viewController;
@property (strong, nonatomic) IBOutlet UITextField *taskTitle;
@property (strong, nonatomic) IBOutlet UISegmentedControl *taskDifficulty;
@property (strong, nonatomic) IBOutlet UITextField *taskReward;
@end
