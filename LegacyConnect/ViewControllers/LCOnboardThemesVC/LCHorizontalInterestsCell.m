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
  LCHorizontalInterestCollectionCell *cell = (LCHorizontalInterestCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
  if ([LCOnboardingHelper isInterestSelected:self.interestsArray[indexPath.row]]) {
    [LCOnboardingHelper removeInterest:self.interestsArray[indexPath.row]];
    [cell setInterestSelected:NO];
  }
  else
  {
    [LCOnboardingHelper addCause:nil andInterest:self.interestsArray[indexPath.row]];
    [cell setInterestSelected:YES];
  }
}
//adding section header






//- (void)loadInterestTable
//{
//  for (UIView *sub in self.horizontalTable.subviews) {
//    [sub removeFromSuperview];
//  }
//  CGFloat spacing = 8;
//  float iconSize  = (self.horizontalTable.frame.size.height - 2*spacing);
////  self.horizontalTable.layer.borderColor = [UIColor redColor].CGColor;
////  self.horizontalTable.layer.borderWidth = 3;
//
//  for (int i = 0; i<self.interestsArray.count; i++) {
//    LCInterest *interest = self.interestsArray[i];
//    UIImageView *interestCell = [[UIImageView alloc] init];
//    [interestCell setBackgroundColor:GRAY_BACK];
//    interestCell.clipsToBounds = YES;
//    interestCell.layer.cornerRadius = 5;
//    [interestCell sd_setImageWithURL:[NSURL URLWithString:interest.logoURLSmall] placeholderImage:nil];
//    interestCell.frame = CGRectMake((i+1)*spacing + i*iconSize, spacing, iconSize, iconSize);
//    [self.horizontalTable addSubview:interestCell];
//
//    LCInterestSelectionButton *selectionButton = [[LCInterestSelectionButton alloc] initWithFrame:CGRectMake(0, 0, interestCell.frame.size.width, interestCell.frame.size.height)];
//    [interestCell addSubview:selectionButton];
//    float checkMarkSize = 25, checkMarkBoarder = 8;
//    UIImageView *checkMark = [[UIImageView alloc] initWithFrame:CGRectMake(interestCell.frame.size.width - checkMarkSize- checkMarkBoarder, checkMarkBoarder, checkMarkSize, checkMarkSize)];
//    [interestCell addSubview:checkMark];
//    selectionButton.checkMark = checkMark;
//    checkMark
//
//    UILabel *interestName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, interestCell.frame.size.width, interestCell.frame.size.height)];
//    [interestCell addSubview:interestName];
//    interestName.text = interest.name;
//    interestName.numberOfLines = 0;
//    interestName.textAlignment = NSTextAlignmentCenter;
//    [interestName setTextColor:[UIColor colorWithRed:247.0f/255.0 green:247.0f/255.0 blue:247.0f/255.0 alpha:1]];
//    [interestName setFont:[UIFont fontWithName:@"Gotham-Medium" size:14]];
//  }
//}

//- (BOOL)interestisSelected :(LCInterest *)interest
//{
//  BOOL isSelected = NO;
//  for (LCInterest *intrst in [self.selectedItems objectAtIndex:1]) {
//    if ([interest.interestID isEqualToString:intrst.interestID]) {
//      isSelected = YES;
//      break;
//    }
//  }
//  return isSelected;
//}

@end
