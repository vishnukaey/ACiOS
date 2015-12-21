//
//  LCOnboardInterestsVC.m
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardInterestsVC.h"
#import "LCHorizontalInterestCollectionCell.h"
#import "LCOnboardingHelper.h"

@interface LCOnboardInterestsVC ()

@end

@implementation LCOnboardInterestsVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navBarTitle.text = [self.theme.name uppercaseString];
  
  //self.collectionViewCellSize  = CGSizeMake(105, 135);
  [self startFetchingResults];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
  [LCThemeAPIManager getInterestsForThemeId:self.theme.themeID lastId:nil withSuccess:^(NSArray *responses) {
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
  
  [LCThemeAPIManager getInterestsForThemeId:self.theme.themeID lastId:[(LCInterest*)[self.results lastObject] interestID] withSuccess:^(NSArray *responses) {
    
    BOOL hasMoreData = [(NSArray*)responses count] >= 10;
    [self didFetchNextResults:responses haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

- (IBAction)backButtonAction:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma CollectionView Delegates

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  LCCOLLECTIONVIEW_cellForItemAtIndexPath
  static NSString *identifier = @"LCHorizontalInterestCollectionCell";
  
  LCHorizontalInterestCollectionCell *cell = (LCHorizontalInterestCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  
  LCInterest *interstObj = [self.results objectAtIndex:indexPath.row];
  cell.interest = interstObj;
  [cell setInterestSelected:[LCOnboardingHelper isInterestSelected:interstObj]];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCHorizontalInterestCollectionCell *cell = (LCHorizontalInterestCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
  if ([LCOnboardingHelper isInterestSelected:self.results[indexPath.row]]) {
    [LCOnboardingHelper removeInterest:self.results[indexPath.row]];
    [cell setInterestSelected:NO];
  }
  else
  {
    [LCOnboardingHelper addCause:nil andInterest:self.results[indexPath.row]];
    [cell setInterestSelected:YES];
  }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return CGSizeMake(105, 105);
}

@end
