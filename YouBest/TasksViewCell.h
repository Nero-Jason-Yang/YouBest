//
//  TasksViewCell.h
//  YouBest
//
//  Created by Jason Yang on 14/11/10.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *subtitle;
@property (strong, nonatomic) IBOutlet UILabel *worth;
@property (strong, nonatomic) IBOutlet UIImageView *symbol;

@end
