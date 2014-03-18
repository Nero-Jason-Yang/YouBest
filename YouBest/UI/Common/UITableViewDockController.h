//
//  UITableViewDockController.h
//  YouBest
//
//  Created by Jason Yang on 14-3-18.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : uint8_t {
    UITableViewDockSide_Header,
    UITableViewDockSide_Footer,
} UITableViewDockSide;
@protocol UITableViewDockItemDelegate;
@class UITableViewDockItem;

@interface UITableViewDockController : UITableViewController
@property (readonly) UITableViewDockItem *headerDockItem;
@property (readonly) UITableViewDockItem *footerDockItem;
@end

@interface UITableViewDockItem : NSObject
@property (nonatomic) BOOL visible;
@property (nonatomic) NSString *title;
@property (nonatomic) CGFloat height;
@property (nonatomic) id<UITableViewDockItemDelegate> delegate;
@property (nonatomic,readonly) UITableViewDockSide dockSide;
- (BOOL)update;
@end

@protocol UITableViewDockItemDelegate <NSObject>
- (void)tableViewDockItemDidPress:(UITableViewDockItem *)dockItem;
@end
