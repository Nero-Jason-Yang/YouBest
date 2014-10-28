//
//  TabsView.m
//  YouBest
//
//  Created by Yang Jason on 14/10/28.
//  Copyright (c) 2014年 family. All rights reserved.
//

#import "TabsView.h"

@interface TabsView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@end

@implementation TabsView

- (id)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self registerClass:[TabsViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    TabsViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    CGFloat r = rand() %255;
    CGFloat g = rand() %255;
    CGFloat b = rand() %255;
    cell.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    cell.tintColor = [UIColor redColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40, 40);
}

@end

@implementation TabsViewCell


@end
