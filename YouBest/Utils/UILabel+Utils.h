//
//  UILabel+Utils.h
//  YouBest
//
//  Created by Jason Yang on 14-2-28.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utils)

- (CGSize)sizeWithString:(NSString *)string constrainedToSize:(CGSize)maxsize;

@end
