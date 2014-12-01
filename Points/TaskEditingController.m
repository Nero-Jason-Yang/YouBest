//
//  TaskEditingController.m
//  Points
//
//  Created by Jason Yang on 14/11/21.
//  Copyright (c) 2014年 me. All rights reserved.
//

#import "TaskEditingController.h"
#import "Database.h"

@interface TaskEditingController ()
@property (nonatomic,readonly) TaskInfo *info;
@property (nonatomic,readonly) NSArray *templates;
@end

@implementation TaskEditingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _info = [[TaskInfo alloc] init];
    _templates = [Database sharedDatabase].allTasks;
}

- (IBAction)onDone:(id)sender {
    if (self == self.navigationController.visibleViewController) {
        TaskEditingCell *cell = (TaskEditingCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (cell) {
            self.info.icon = cell.icon.text;
            self.info.symbol = cell.symbol.text;
            self.info.title = cell.title.text;
            self.info.subtitle = cell.subtitle.text;
            self.info.worth = @(cell.worth.text.integerValue);
        }
        
        if (self.delegate) {
            [self.delegate taskEditingController:self didFinishTaskWithInfo:self.info];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    }
    else {
        return self.templates.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section && 0 == indexPath.row) {
        static NSString *identifier = @"Cell-Editing";
        TaskEditingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.icon.text = self.info.icon;
        cell.symbol.text = self.info.symbol;
        cell.title.text = self.info.title;
        cell.subtitle.text = self.info.subtitle;
        cell.worth.text = self.info.worth.description;
        return cell;
    }
    
    if (1 == indexPath.section) {
        static NSString *identifier = @"Cell-Template";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        TaskInfo *info = self.templates[indexPath.row];
        cell.textLabel.text = info.title;
        cell.detailTextLabel.text = info.subtitle;
        //cell.worth.text = info.worth.description;
        return cell;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (1 == section) {
        return @"Templates";
    }
    return nil;
}

#pragma mark <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 122;
    }
    else {
        return tableView.rowHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (1 == section) {
        return 36;
    }
    else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        TaskInfo *info = self.templates[indexPath.row];
        TaskEditingCell *cell = (TaskEditingCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.icon.text = info.icon;
        cell.symbol.text = info.symbol;
        cell.title.text = info.title;
        cell.subtitle.text = info.subtitle;
        cell.worth.text = info.worth.description;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0 && [cell isKindOfClass:TaskEditingCell.class]) {
        TaskEditingCell *taskCell = (TaskEditingCell *)cell;
        self.info.icon = taskCell.icon.text;
        self.info.symbol = taskCell.symbol.text;
        self.info.title = taskCell.title.text;
        self.info.subtitle = taskCell.subtitle.text;
        self.info.worth = @(taskCell.worth.text.integerValue);
    }
}

@end

@interface TaskEditingCell ()
@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@end

@implementation TaskEditingCell

- (IBAction)onStepper:(id)sender {
    self.worth.text = @(((UIStepper *)sender).value).description;
}

@end
