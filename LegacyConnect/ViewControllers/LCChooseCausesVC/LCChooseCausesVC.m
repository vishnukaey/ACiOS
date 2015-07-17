//
//  LCChooseCausesVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseCausesVC.h"
#import "LCChooseCausesCollectionViewCell.h"

@interface LCChooseCausesVC ()

@end

@implementation LCChooseCausesVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  if([collectionView isEqual:_interestsCollectionView])
    return 10;
  else
    return 20;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if([collectionView isEqual:_interestsCollectionView])
  {
    static NSString *cellIdentifier = @"interestsCollectionViewCell";
    
    LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
  }
  else
  {
    static NSString *cellIdentifier = @"causesCollectionViewCell";
    
    LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
  }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  CGFloat pageWidth = _causesCollectionView.frame.size.width;
  float currentPage = _causesCollectionView.contentOffset.x / pageWidth;
  
  if (0.0f != fmodf(currentPage, 1.0f))
  {
    _pagecontroller.currentPage = currentPage + 1;
  }
  else
  {
    _pagecontroller.currentPage = currentPage;
  }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  cell.selectionButton.selected = !cell.selectionButton.selected;
}

@end
