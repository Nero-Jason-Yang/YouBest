//
//  MainViewController.m
//  YouBest
//
//  Created by Jason Yang on 14/11/17.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () <UITabBarControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.currentViewController = self.viewControllers.firstObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma internal

- (void)setCurrentViewController:(UIViewController *)viewController {
    NSString *title = viewController.title;
    if (0 == title.length) {
        title = viewController.navigationItem.title;
    }
    if (0 == title.length) {
        title = viewController.tabBarItem.title;
    }
    self.navigationItem.title = title;
    self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;
}

#pragma <UITabBarControllerDelegate>

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    self.currentViewController = viewController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
