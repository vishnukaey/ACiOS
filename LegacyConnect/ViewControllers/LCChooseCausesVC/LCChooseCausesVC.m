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
{
  NSMutableArray *selectedCauses;
  NSMutableArray *selectedInterests;
}
@end

@implementation LCChooseCausesVC

- (void)viewDidLoad {
  [super viewDidLoad];
  selectedCauses = [[NSMutableArray alloc] init];
  selectedInterests = [[NSMutableArray alloc] init];
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
    return 50;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if([collectionView isEqual:_interestsCollectionView])
  {
    static NSString *cellIdentifier = @"interestsCollectionViewCell";
    
    LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
      NSArray *cells =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCChooseCausesCollectionViewCell class]) owner:nil options:nil];
      cell=cells[0];
    }
    if([selectedInterests containsObject:indexPath])
    {
      cell.selectionButton.selected =YES;
    }
    else
    {
      cell.selectionButton.selected=NO;
    }
    return cell;
  }
  else
  {
    static NSString *cellIdentifier = @"causesCollectionViewCell";
    LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if([selectedCauses containsObject:indexPath])
    {
      cell.selectionButton.selected =YES;
    }
    else
    {
      cell.selectionButton.selected=NO;
    }
    _pagecontroller.numberOfPages = floor(self.causesCollectionView.contentSize.width /
                                          self.causesCollectionView.frame.size.width) + 1;
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
  if([collectionView isEqual:_causesCollectionView])
  {
    if([selectedCauses containsObject:indexPath])
    {
      [selectedCauses removeObject:indexPath];
    }
    else
    {
      [selectedCauses addObject:indexPath];
    }
    [self.causesCollectionView reloadData];
  }
  else
  {
    if([selectedInterests containsObject:indexPath])
    {
      [selectedInterests removeObject:indexPath];
    }
    else
    {
      [selectedInterests addObject:indexPath];
    }
    [self.interestsCollectionView reloadData];
  }
}

@end
