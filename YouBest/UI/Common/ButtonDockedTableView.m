//
//  ButtonDockedTableView.m
//  YouBest
//
//  Created by Jason Yang on 14-3-12.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "ButtonDockedTableView.h"

#define FooterButton_BackgroundColor_Up   [UIColor colorWithWhite:0.95 alpha:0.9]
#define FooterButton_BackgroundColor_Down [UIColor colorWithWhite:0.85 alpha:1.0]

@interface ButtonDockedTableView ()
{
    // super.footerView = _footerContainer (_footerView + _footerPlaceholder)
    UIView *_footerContainer;
    UIView *_footerView;
    UIView *_footerPlaceholder;
    
    NSNumber *_footerButtonHeight;
    UIButton *_footerButton;
}
@end

@implementation ButtonDockedTableView

- (UIView *)tableFooterView
{
    return _footerView;
}

- (void)setTableFooterView:(UIView *)tableFooterView
{
    // TODO
}

- (NSString *)tableFooterButtonTitle
{
    if (_footerButton) {
        return [_footerButton titleForState:UIControlStateNormal];
    }
    return nil;
}

- (void)setTableFooterButtonTitle:(NSString *)tableFooterButtonTitle
{
    UIView *superview = self.superview;
    //NSParameterAssert(superview);
    if (!superview) {
        return;
    }
    
    if (tableFooterButtonTitle) {
        // footerButton
        NSUInteger buttonHeight = self.tableFooterButtonHeight;
        if (!_footerButton) {
            _footerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [_footerButton addTarget:self action:@selector(onFooterButtonDown:) forControlEvents:UIControlEventTouchDown];
            [_footerButton addTarget:self action:@selector(onFooterButtonUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [_footerButton addTarget:self action:@selector(onFooterButtonUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        }
        CGRect buttonFrame = CGRectMake(0, self.frame.size.height - buttonHeight, self.frame.size.width, buttonHeight);
        _footerButton.frame = buttonFrame;
        _footerButton.backgroundColor = FooterButton_BackgroundColor_Up;
        [_footerButton setTitle:tableFooterButtonTitle forState:UIControlStateNormal];
        if (!_footerButton.superview) {
            [superview addSubview:_footerButton];
        }
        
        // footerPlaceholder
        CGRect placeholderFrame = CGRectZero;
        placeholderFrame.size = _footerButton.frame.size;
        if (_footerView) {
            placeholderFrame.origin = CGPointMake(0, _footerView.frame.size.height);
        }
        if (!_footerPlaceholder) {
            _footerPlaceholder = [[UIView alloc] initWithFrame:placeholderFrame];
        }
        else {
            _footerPlaceholder.frame = placeholderFrame;
        }
        
        // footerContainer
        if (!_footerContainer) {
            _footerContainer = [[UIView alloc] initWithFrame:_footerPlaceholder.frame];
            super.tableFooterView = _footerContainer;
        }
        else {
            CGRect containerFrame = _footerContainer.frame;
            containerFrame.size = CGSizeMake(containerFrame.size.width, placeholderFrame.origin.y + placeholderFrame.size.height);
            _footerContainer.frame = containerFrame;
        }
        
        if (!_footerPlaceholder.superview) {
            [_footerContainer addSubview:_footerPlaceholder];
        }
    }
    else {
        @autoreleasepool
        {
            if (_footerButton) {
                [_footerButton removeFromSuperview];
                _footerButton = nil;
            }
            
            if (_footerPlaceholder) {
                [_footerPlaceholder removeFromSuperview];
                _footerPlaceholder = nil;
                
                if (_footerView) {
                    CGRect frame = _footerContainer.frame;
                    frame.size = _footerView.frame.size;
                    _footerContainer.frame = frame;
                }
                else {
                    [_footerContainer removeFromSuperview];
                    super.tableFooterView = nil;
                }
            }
        }
    }
}

- (NSUInteger)tableFooterButtonHeight
{
    if (_footerButtonHeight) {
        return _footerButtonHeight.unsignedIntegerValue;
    }
    
    return 44;
}

- (void)setTableFooterButtonHeight:(NSUInteger)tableFooterButtonHeight
{
    if (_footerButton) {
        // TODO
        // 1. resize footer button
        // 2. resize footer view container
    }
    
    _footerButtonHeight = [NSNumber numberWithUnsignedInteger:tableFooterButtonHeight];
}

#pragma mark actions

- (void)onFooterButtonDown:(id)sender
{
    UIButton *button = sender;
    NSParameterAssert([button isKindOfClass:UIButton.class]);
    button.backgroundColor = FooterButton_BackgroundColor_Down;
}

- (void)onFooterButtonUpInside:(id)sender
{
    UIButton *button = sender;
    NSParameterAssert([button isKindOfClass:UIButton.class]);
    button.backgroundColor = FooterButton_BackgroundColor_Up;
}

- (void)onFooterButtonUpOutside:(id)sender
{
    UIButton *button = sender;
    NSParameterAssert([button isKindOfClass:UIButton.class]);
    button.backgroundColor = FooterButton_BackgroundColor_Up;
}

@end
