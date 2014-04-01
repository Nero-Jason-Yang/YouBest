//
//  TaskEditingViewController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "TaskEditingViewController.h"
#import "AppDelegate.h"
#import "Database.h"
#import "YBPlayer.h"

@interface TaskEditingViewController ()

@end

@implementation TaskEditingViewController

+ (id)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TaskEditingView" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"TaskEditingViewController"];
    if ([controller isKindOfClass:TaskEditingViewController.class]) {
        return controller;
    }
    controller = storyboard.instantiateInitialViewController;
    if ([controller isKindOfClass:TaskEditingViewController.class]) {
        return controller;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)onActionDone:(id)sender
{
    YBPlayer *player = AppDelegate.sharedAppDelegate.currentPlayer;
    if (!player) {
        return;
    }
    
    NSString *taskTitle = self.taskTitle.text;
    if (0 == taskTitle.length) {
        return;
    }
    
    NSInteger taskDifficulty = self.taskDifficulty.selectedSegmentIndex;
    NSInteger taskReward = self.taskReward.text.integerValue;
    if (taskReward < 0) {
        taskReward = 0;
    }
    
    Database *db = Database.sharedDatabase;
    [db.context performBlock:^{
        MOTaskInstance *task = [db.context createObjectForEntityName:Entity_TaskInstance];
        task.playerID = player.identity;
        task.title = taskTitle;
        task.value = [NSNumber numberWithInteger:taskReward];
        task.difficulty = [NSNumber numberWithShort:taskDifficulty];
        task.creationDate = NSDate.date;
        [db.context save];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
