//
//  LCOnboardCausesVC.m
//  LegacyConnect
//
//  Created by Akhil K C on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardCausesVC.h"

@interface LCOnboardCausesVC ()

@end

@implementation LCOnboardCausesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//  float size = ([[UIScreen mainScreen] bounds].size.width - 15*4)/3;
//  causesCollectionView.collectionViewCellSize  = CGSizeMake(size, size);
//  causesCollectionView.collectionViewCellSize = CGSizeMake(size, size + 20);
//  causesCollectionView.collec
  
  float size = ([[UIScreen mainScreen] bounds].size.width - 15*4)/3;
  self.collectionViewCellSize  = CGSizeMake(105, 135);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma CollectionView Delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  return 8;
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  static NSString *identifier = @"causesCell";
  
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

//  
//  UIImageView *collectionImageView = (UIImageView *)[cell viewWithTag:100];
//  
//  collectionImageView.image = [UIImage imageNamed:[collectionImages objectAtIndex:indexPath.row]];
  return cell;
  
}

//- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//  float size = ([[UIScreen mainScreen] bounds].size.width - 8*4)/3;
//  return CGSizeMake(size, size);  // will be w120xh100 or w190x100
//  // if the width is higher, only one image will be shown in a line
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//  return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
//}

@end
