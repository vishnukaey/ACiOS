//
//  LCOnboardCausesVC.m
//  LegacyConnect
//
//  Created by Akhil K C on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardCausesVC.h"
#import "LCChooseCausesCollectionViewCell.h"
#import "LCOnboardingHelper.h"


@implementation LCOnboardCausesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  self.navBarTitle.text = [self.interest.name uppercaseString];
  self.collectionView.allowsMultipleSelection = YES;
  
  [self startFetchingResults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
  [LCThemeAPIManager getCausesForInterestID:self.interest.interestID andLastCauseID:nil withSuccess:^(NSArray *responses) {
    [MBProgressHUD hideAllHUDsForView:self.collectionView animated:YES];
    BOOL hasMoreData = [(NSArray*)responses count] >= 10;
    [self didFetchNextResults:responses haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.collectionView animated:YES];
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  
  [LCThemeAPIManager getCausesForInterestID:self.interest.interestID andLastCauseID:[(LCCause*)[self.results lastObject] causeID] withSuccess:^(NSArray *responses) {
    
    BOOL hasMoreData = [(NSArray*)responses count] >= 10;
    [self didFetchNextResults:responses haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

- (IBAction)backButtonAction:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - CollectionView Delegates

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  LCCOLLECTIONVIEW_cellForItemAtIndexPath
  static NSString *identifier = @"causesCell";
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  cell.cause = self.results[indexPath.item];
  
  if ([LCOnboardingHelper isCauseSelected:self.results[indexPath.item]]) {
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
  [LCOnboardingHelper addCause:self.results[indexPath.item] andInterest:self.interest];
  [cell setCellSelected:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  [LCOnboardingHelper removeCause:self.results[indexPath.item]];
  [cell setCellSelected:NO];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  float size = ([[UIScreen mainScreen] bounds].size.width - 15*4)/3;
  return CGSizeMake(size, 140);
}

@end
