//
//  InstanceListViewCell.h
//  YouBest
//
//  Created by Jason Yang on 14-2-20.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstanceListViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIImageView *coin;
@property (strong, nonatomic) IBOutlet UILabel *value;
@end
