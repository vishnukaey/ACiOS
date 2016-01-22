//
//  LCSearchInterestsViewController.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSearchInterestsViewController.h"
#import "LCChooseInterestCVC.h"
#import "LCSingleInterestVC.h"

@interface LCSearchInterestsViewController ()

@end

@implementation LCSearchInterestsViewController

- (void)setInterestsArray:(NSArray*)interests
{
  [self startFetchingResults];
  BOOL hasMoreData = interests.count >= 20;
  [self didFetchResults:interests haveMoreData:hasMoreData];
  [self.collectionView reloadData];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCSearchAPIManager getInterestsSearchResultsWithSearchKey:_searchKey withFastId:[(LCInterest*)[self.results lastObject] interestID] success:^(id response) {
    BOOL hasMoreData = [(NSArray*)response count] >= 20;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.noResultsView = [LCUtilityManager getSearchNoResultViewWithText:NSLocalizedString(@"no_results_found", nil)];
  float size = ([[UIScreen mainScreen] bounds].size.width - 15*4)/3;
  self.collectionViewCellSize = CGSizeMake(size, size + 20);
  
  if (self.results.count > 0) {
    [self hideNoResultsView];
  } else {
    [self showNoResultsView];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (UIView *)getNOResultLabel
{
  UILabel * noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
  [noResultLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
  [noResultLabel setTextColor:[UIColor colorWithRed:35.0/255 green:31.0/255 blue:32.0/255 alpha:1]];
  noResultLabel.textAlignment = NSTextAlignmentCenter;
  noResultLabel.numberOfLines = 2;
  [noResultLabel setText:@"No Results Found"];
  return noResultLabel;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCCOLLECTIONVIEW_cellForItemAtIndexPath
  static NSString *identifier = @"interestsCollectionViewCell";
  LCChooseInterestCVC *cell = (LCChooseInterestCVC*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  cell.interest = self.results[indexPath.item];
  return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCInterest *selectedInterest = self.results[indexPath.item];
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kInterestsStoryBoardIdentifier bundle:nil];
  LCSingleInterestVC *interestVC = [storyboard instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
  interestVC.interest = selectedInterest;
  [self.navigationController pushViewController:interestVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  float size = ([[UIScreen mainScreen] bounds].size.width - 15*4)/3;
  return CGSizeMake(size, 140);
}

@end
