	//
//  LCCausesCollectionTableViewCell.m
//  LegacyConnect
//
//  Created by Akhil K C on 12/16/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCCausesCollectionTableViewCell.h"
#import "LCChooseCausesCollectionViewCell.h"
#import "LCOnboardingHelper.h"

@implementation LCCausesCollectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
  self.collectionView.allowsMultipleSelection = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadCollectionView
{
  self.causesArray = [LCOnboardingHelper sortCausesInInterest:self.interest];
  [self.collectionView reloadData];
  
//  [self.collectionView performBatchUpdates:^{
//    for (NSInteger i = 0; i < self.causesArray.count; i++) {
//      NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
//      NSInteger j = [self.causesArray indexOfObject:self.causesArray[i]];
//      NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:j inSection:0];
//      [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//    }
//  } completion:^(BOOL finished) {
//    [self.collectionView reloadData];
//  }];
}

#pragma CollectionView Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  return self.causesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  static NSString *identifier = @"causesCell";
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  cell.cause = self.causesArray[indexPath.item];
  if ([LCOnboardingHelper isCauseSelected:self.causesArray[indexPath.item]]) {
    [cell setCellSelected:YES];
  }
  else {
    [cell setCellSelected:NO];
  }
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  
  LCCause *cause = self.causesArray[indexPath.item];
  if ([LCOnboardingHelper isCauseSelected:cause]) {
    [LCOnboardingHelper removeCause:self.causesArray[indexPath.item]];
    [cell setCellSelected:NO];
  }
  else {
    [LCOnboardingHelper addCause:cause andInterest:self.interest];
    [cell setCellSelected:YES];
  }
  
  [self reloadCollectionView];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

  CGSize size = CGSizeMake(105, 140);
  return size;
}


@end
