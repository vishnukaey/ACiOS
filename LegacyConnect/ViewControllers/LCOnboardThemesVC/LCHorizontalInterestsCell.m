//
//  LCHorizontalInterestsCell.m
//  LegacyConnect
//
//  Created by Jijo on 12/15/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCHorizontalInterestsCell.h"
#import "LCOnboardingHelper.h"
#import "LCHorizontalInterestCollectionCell.h"

#define GRAY_BACK [UIColor colorWithRed:111.0f/255.0 green:113.0f/255.0 blue:121.0f/255.0 alpha:1]
@interface LCHorizontalInterestsCell ()

@property(nonatomic, retain)IBOutlet UICollectionView *interestsCollection;

@end

@implementation LCHorizontalInterestsCell

- (void)setInterestsArray:(NSArray *)interestsArray
{
  _interestsArray = interestsArray;
  [self.interestsCollection reloadData];
}

//- (void)reloadCollectionForIndex :(NSIndexPath *)index
//{
//  self.interestsArray = [LCOnboardingHelper sortInterests:self.interestsArray forTheme:self.theme];
//  
//  [self.interestsCollection performBatchUpdates:^{
//    NSInteger newIndex = [self.interestsArray indexOfObject:cause];
//    NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:newIndex inSection:indexPath.section];
//    NSInteger oldIndex = [causesArrayCopy indexOfObject:cause];
//    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:oldIndex inSection:indexPath.section];
//    [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//  } completion:^(BOOL finished) {
//    [self.collectionView reloadData];
//  }];
//
//}


#pragma mark - collectionview delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [self.interestsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identifier = @"LCHorizontalInterestCollectionCell";
  
  LCHorizontalInterestCollectionCell *cell = (LCHorizontalInterestCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  
  LCInterest *interstObj = [self.interestsArray objectAtIndex:indexPath.row];
  cell.interest = interstObj;
  [cell setInterestSelected:[LCOnboardingHelper isInterestSelected:interstObj]];
  return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  float size = ([[UIScreen mainScreen] bounds].size.width - 8*4)/3;
  return CGSizeMake(size, size);  // will be w120xh100 or w190x100
  // if the width is higher, only one image will be shown in a line
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
  return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
  return 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCInterest *currentInterest = self.interestsArray[indexPath.row];
  LCHorizontalInterestCollectionCell *cell = (LCHorizontalInterestCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
  if ([LCOnboardingHelper isInterestSelected:currentInterest]) {
    [LCOnboardingHelper removeInterest:currentInterest];
    [cell setInterestSelected:NO];
  }
  else
  {
    [LCOnboardingHelper addCause:nil andInterest:currentInterest];
    [cell setInterestSelected:YES];
  }
// 
//    [self.nextButton setEnabled:![LCOnboardingHelper noInterestSelected]];
//  
//  NSArray *interstsCopy = [self.interestsArray copy];
//  self.interestsArray = [LCOnboardingHelper sortInterests:self.interestsArray forTheme:self.theme];
//  
//  [self.interestsCollection performBatchUpdates:^{
//    NSInteger newIndex = [self.interestsArray indexOfObject:currentInterest];
//    NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:newIndex inSection:indexPath.section];
//    NSInteger oldIndex = [interstsCopy indexOfObject:currentInterest];
//    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:oldIndex inSection:indexPath.section];
//    [self.interestsCollection moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//  } completion:^(BOOL finished) {
//    [self.interestsCollection reloadData];
//  }];

}

@end
