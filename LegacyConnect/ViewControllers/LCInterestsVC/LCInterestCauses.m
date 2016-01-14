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

@implementation LCInterestCauses

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self initailSetup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) initailSetup {

  self.noResultsView = [LCUtilityManager getSearchNoResultViewWithText:NSLocalizedString(@"no_causes_to_display", nil)];
}

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
    [self didFetchResults:responses haveMoreData:hasMoreData];
    if (self.results.count > 0) {
      [self hideNoResultsView];
    } else {
      [self showNoResultsView];
    }
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
  cell.selectionButton.hidden = YES;
  
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
  LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
  vc.cause = self.results[indexPath.item];
  [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  float size = ([[UIScreen mainScreen] bounds].size.width - 15*4)/3;
  return CGSizeMake(size, 140);
}


#pragma mark - ScrollView delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [self.delegate scrollViewScrolled:scrollView];
}

@end
