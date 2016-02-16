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
  self.causesArray = self.interest.causes;
  [self.collectionView reloadData];
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
  
  LCCause *currentCause = self.causesArray[indexPath.item];
  [LCOnboardingHelper addCause:currentCause andInterest:self.interest];
  [cell setCellSelected:YES];

//  NSArray *causesArrayCopy = [self.causesArray copy];
//  
//  self.causesArray = [LCOnboardingHelper sortAndCombineCausesArray:self.causesArray];
//  [self.collectionView performBatchUpdates:^{
//      NSInteger newIndex = [self.causesArray indexOfObject:cause];
//      NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:newIndex inSection:indexPath.section];
//      NSInteger oldIndex = [causesArrayCopy indexOfObject:cause];
//      NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:oldIndex inSection:indexPath.section];
//      [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//  } completion:^(BOOL finished) {
//    [self.collectionView reloadData];
//  }];
  
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  
  LCCause *currentCause = self.causesArray[indexPath.item];
  [LCOnboardingHelper removeCause:currentCause];
  [cell setCellSelected:NO];
}

@end
