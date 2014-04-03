//
//  GiftEditingViewController.m
//  YouBest
//
//  Created by Jason Yang on 14-3-7.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "GiftEditingViewController.h"
#import "AppDelegate.h"
#import "Database.h"
#import "YBPlayer.h"

@interface GiftEditingViewController ()
@property (strong, nonatomic) IBOutlet UITextField *giftTitle;
@property (strong, nonatomic) IBOutlet UITextField *giftValue;
@end

@implementation GiftEditingViewController

+ (id)viewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GiftEditingView" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"GiftEditingViewController"];
    if ([controller isKindOfClass:GiftEditingViewController.class]) {
        return controller;
    }
    controller = storyboard.instantiateInitialViewController;
    if ([controller isKindOfClass:GiftEditingViewController.class]) {
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
    
    NSString *title = self.giftTitle.text;
    if (0 == title.length) {
        return;
    }
    
    NSInteger value = self.giftValue.text.integerValue;
    if (value < 0) {
        value = 0;
    }
    
    Database *db = Database.sharedDatabase;
    [db.context performBlock:^{
        MOGiftInstance *gift = [db.context createObjectForEntityName:Entity_GiftInstance];
        gift.playerID = player.identity;
        gift.title = title;
        gift.value = [NSNumber numberWithInteger:value];
        gift.creationDate = NSDate.date;
        [db.context save];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
