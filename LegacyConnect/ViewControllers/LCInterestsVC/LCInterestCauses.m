//
//  LCInterestCauses.m
//  LegacyConnect
//
//  Created by Akhil K C on 1/4/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCInterestCauses.h"
#import "LCChooseCausesCollectionViewCell.h"
#import "LCSingleCauseVC.h"

//static NSInteger kCausesCellWidth = 105;
//static NSInteger kCausesCellHeight = 140;

@implementation LCInterestCauses

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) loadCausesInCurrentInterest
{
  [self startFetchingResults];
}

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



#pragma mark - CollectionView Delegates

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  LCCOLLECTIONVIEW_cellForItemAtIndexPath
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCausesCellID forIndexPath:indexPath];
  cell.cause = self.results[indexPath.item];
  
//  if ([LCOnboardingHelper isCauseSelected:self.results[indexPath.item]]) {
//    [cell setCellSelected:YES];
//  }
//  else {
//    [cell setCellSelected:NO];
//  }
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
  LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
  vc.cause = self.results[indexPath.item];
  [self.navigationController pushViewController:vc animated:YES];
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
//  [LCOnboardingHelper removeCause:self.results[indexPath.item]];
//  [cell setCellSelected:NO];
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//  return CGSizeMake(kCausesCellWidth, kCausesCellHeight);;
//}

#pragma mark - ScrollView delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.delegate scrollViewScrolled:scrollView];
}

@end
