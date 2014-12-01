//
//  TasksViewController.m
//  Points
//
//  Created by Jason Yang on 14/11/21.
//  Copyright (c) 2014年 me. All rights reserved.
//

#import "TasksViewController.h"
#import "TaskEditingController.h"
#import "Database.h"

@interface TasksViewController () <TaskEditingDelegate>
@property (nonatomic,readonly) NSMutableArray *tasks;
@end

@implementation TasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tasks = [Database sharedDatabase].allTasks.mutableCopy;
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    TasksViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    TaskInfo *info = self.tasks[indexPath.row];
    cell.textLabel.text = info.title;
    cell.detailTextLabel.text = info.subtitle;
    //cell.worth.text = task.worth.description;
    
    return cell;
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"New-Task"]) {
        TaskEditingController *controller = segue.destinationViewController;
        if ([controller isKindOfClass:TaskEditingController.class]) {
            controller.delegate = self;
        }
    }
}

#pragma mark <TaskEditingDelegate>

- (void)taskEditingController:(TaskEditingController *)controller didFinishTaskWithInfo:(TaskInfo *)info {
    [self.tasks insertObject:info atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end

@implementation TasksViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
