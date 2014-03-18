//
//  UITableViewDockController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-18.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "UITableViewDockController.h"

@interface UITableViewDockController ()
- (BOOL)updateDockItem:(UITableViewDockItem *)item;
@end

@interface UITableViewDockItem ()
- (id)initWithController:(UITableViewDockController *)controller dockSide:(UITableViewDockSide)dockSide;
@property (nonatomic,readonly,weak) UITableViewDockController *controller;
@property (nonatomic,readonly) UIButton *button;
@property (nonatomic) UIView *agentView;
@end

#define TableViewDockItem_Button_BackgroundColor_Up   [UIColor colorWithWhite:0.95 alpha:0.9]
#define TableViewDockItem_Button_BackgroundColor_Down [UIColor colorWithWhite:0.85 alpha:1.0]

@implementation UITableViewDockController
{
    UIView *_footerAgentView;
    UIView *_headerAgentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _headerDockItem = [[UITableViewDockItem alloc] initWithController:self dockSide:UITableViewDockSide_Header];
    _footerDockItem = [[UITableViewDockItem alloc] initWithController:self dockSide:UITableViewDockSide_Footer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.footerDockItem update];
    [self.headerDockItem update];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.footerDockItem update];
    [self.headerDockItem update];
}

- (BOOL)updateDockItem:(UITableViewDockItem *)item
{
    CGRect frame = self.view.frame;
    
    UIView *superview = self.tableView.superview;
    frame = superview.frame;
    if (!superview) {
        return NO;
    }
    
    UIButton *button = item.button;
    if (superview && button && item.visible) {
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame = superview.frame;
        CGRect buttonFrame;
        switch (item.dockSide) {
            case UITableViewDockSide_Footer:
                buttonFrame = CGRectMake(0, tableViewFrame.size.height - item.height, tableViewFrame.size.width, item.height);
                break;
            case UITableViewDockSide_Header:
                buttonFrame = CGRectMake(0, 0, tableViewFrame.size.width, item.height);
                break;
            default:
                return NO;
        }
        button.frame = buttonFrame;
        button.backgroundColor = TableViewDockItem_Button_BackgroundColor_Up;
        //if (!button.superview)
        {
            [superview addSubview:button];
        }
        
        if (item.dockSide == UITableViewDockSide_Footer) {
            if (!_footerAgentView) {
                _footerAgentView = [[UIView alloc] initWithFrame:CGRectZero];
            }
            
            UIView *tableFooterView = self.tableView.tableFooterView;
            if (_footerAgentView != tableFooterView) {
                self.tableView.tableFooterView = _footerAgentView;
                if (tableFooterView) {
                    [_footerAgentView addSubview:tableFooterView];
                }
            }
            else {
                NSArray *subviews = _footerAgentView.subviews;
                if (subviews.count > 0) {
                    tableFooterView = subviews[0];
                }
            }
            
            CGRect tableFooterFrame = CGRectZero;
            if (tableFooterView) {
                tableFooterFrame = tableFooterView.frame;
                tableFooterFrame.origin = CGPointMake(tableFooterFrame.origin.x, 0);
                tableFooterView.frame = tableFooterFrame;
            }
            
            CGRect footerAgentFrame = CGRectZero;
            footerAgentFrame.size = CGSizeMake(tableFooterFrame.size.width, tableFooterFrame.size.height + item.height);
            _footerAgentView.frame = footerAgentFrame;
        }
        
        if (item.dockSide == UITableViewDockSide_Header) {
            if (!_headerAgentView) {
                _headerAgentView = [[UIView alloc] initWithFrame:CGRectZero];
            }
            
            UIView *tableHeaderView = self.tableView.tableHeaderView;
            if (_headerAgentView != tableHeaderView) {
                self.tableView.tableHeaderView = _headerAgentView;
                if (tableHeaderView) {
                    [_headerAgentView addSubview:tableHeaderView];
                }
            }
            else {
                NSArray *subviews = _headerAgentView.subviews;
                if (subviews.count > 0) {
                    tableHeaderView = subviews[0];
                }
            }
            
            CGRect tableHeaderFrame = CGRectZero;
            if (tableHeaderView) {
                tableHeaderFrame = tableHeaderView.frame;
            }
            
            CGRect footerAgentFrame = CGRectZero;
            footerAgentFrame.size = CGSizeMake(tableHeaderFrame.size.width, tableHeaderFrame.size.height + item.height);
            _headerAgentView.frame = footerAgentFrame;
            
            if (tableHeaderView) {
                tableHeaderFrame.origin = CGPointMake(tableHeaderFrame.origin.x, footerAgentFrame.size.height - item.height);
                tableHeaderView.frame = tableHeaderFrame;
            }
        }
    }
    else {
        if (button) {
            [button removeFromSuperview];
        }
        
        if (item.dockSide == UITableViewDockSide_Footer) {
            if (_footerAgentView) {
                UIView *tableFooterView = nil;
                NSArray *array = _footerAgentView.subviews;
                if (array.count > 0) {
                    tableFooterView = array[0];
                    for (UIView *view in array) {
                        [view removeFromSuperview];
                    }
                }
                if (_footerAgentView == self.tableView.tableFooterView) {
                    self.tableView.tableFooterView = tableFooterView;
                }
            }
        }
        
        if (item.dockSide == UITableViewDockSide_Header) {
            if (_headerAgentView) {
                UIView *tableHeaderView = nil;
                NSArray *array = _headerAgentView.subviews;
                if (array.count > 0) {
                    tableHeaderView = array[0];
                    for (UIView *view in array) {
                        [view removeFromSuperview];
                    }
                }
                if (_headerAgentView == self.tableView.tableHeaderView) {
                    self.tableView.tableHeaderView = tableHeaderView;
                }
            }
        }
    }
    return YES;
}

@end

@implementation UITableViewDockItem

- (id)initWithController:(UITableViewDockController *)controller dockSide:(UITableViewDockSide)dockSide
{
    if (self = [super init]) {
        _controller = controller;
        _dockSide = dockSide;
        _height = 44.0;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    if (title) {
        if (!_button) {
            _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [_button addTarget:self action:@selector(onButtonDown:) forControlEvents:UIControlEventTouchDown];
            [_button addTarget:self action:@selector(onButtonUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [_button addTarget:self action:@selector(onButtonUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        }
        [_button setTitle:title forState:UIControlStateNormal];
    }
    else if (_button) {
        @autoreleasepool {
            [_button removeTarget:self action:@selector(onButtonDown:) forControlEvents:UIControlEventTouchDown];
            [_button removeTarget:self action:@selector(onButtonUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [_button removeTarget:self action:@selector(onButtonUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
            [_button removeFromSuperview];
            _button = nil;
        }
    }
    _title = title;
}

- (void)setHeight:(CGFloat)height
{
    NSParameterAssert(height >= 0);
    _height = height;
}

- (BOOL)header
{
    return self.dockSide == UITableViewDockSide_Header;
}

- (BOOL)footer
{
    return self.dockSide == UITableViewDockSide_Footer;
}

- (BOOL)update
{
    return [self.controller updateDockItem:self];
}

#pragma mark button actions

- (void)onButtonDown:(id)sender
{
    UIButton *button = sender;
    NSParameterAssert([button isKindOfClass:UIButton.class]);
    button.backgroundColor = TableViewDockItem_Button_BackgroundColor_Down;
}

- (void)onButtonUpInside:(id)sender
{
    UIButton *button = sender;
    NSParameterAssert([button isKindOfClass:UIButton.class]);
    button.backgroundColor = TableViewDockItem_Button_BackgroundColor_Up;
    if ([self.delegate respondsToSelector:@selector(tableViewDockItemDidPress:)]) {
        [self.delegate tableViewDockItemDidPress:self];
    }
}

- (void)onButtonUpOutside:(id)sender
{
    UIButton *button = sender;
    NSParameterAssert([button isKindOfClass:UIButton.class]);
    button.backgroundColor = TableViewDockItem_Button_BackgroundColor_Up;
}

@end
