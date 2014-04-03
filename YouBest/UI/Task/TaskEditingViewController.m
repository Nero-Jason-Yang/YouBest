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
@property (strong, nonatomic) IBOutlet UITextField *taskTitle;
@property (strong, nonatomic) IBOutlet UITextField *taskValue;
@property (strong, nonatomic) IBOutlet UISegmentedControl *taskDifficulty;
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
    
    NSString *title = self.taskTitle.text;
    if (0 == title.length) {
        return;
    }
    
    NSInteger value = self.taskValue.text.integerValue;
    if (value < 0) {
        value = 0;
    }
    
    NSInteger difficulty = self.taskDifficulty.selectedSegmentIndex;
    
    Database *db = Database.sharedDatabase;
    [db.context performBlock:^{
        MOTaskInstance *task = [db.context createObjectForEntityName:Entity_TaskInstance];
        task.playerID = player.identity;
        task.title = title;
        task.value = [NSNumber numberWithInteger:value];
        task.difficulty = [NSNumber numberWithShort:difficulty];
        task.creationDate = NSDate.date;
        [db.context save];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
