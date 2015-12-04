//
//  LCSearchCausesViewController.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSearchCausesViewController.h"
#import "LCChooseCausesCollectionViewCell.h"

@interface LCSearchCausesViewController ()

@end

@implementation LCSearchCausesViewController

#pragma mark - API and Pagination
- (void)setCausesArray:(NSArray*)causes
{
  [self startFetchingResults];
  BOOL hasMoreData = causes.count >= 20;
  [self didFetchResults:causes haveMoreData:hasMoreData];
  [self.collectionView reloadData];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  
  [LCAPIManager getCauseSearchResultsWithSearchKey:_searchKey withFastId:[(LCCause*)[self.results lastObject] causeID] success:^(id response) {
    BOOL hasMoreData = [(NSArray*)response count] >= 20;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.noResultsView = [LCUtilityManager getSearchNoResultViewWithText:NSLocalizedString(@"no_results_found", nil) andViewWidth:CGRectGetWidth(self.collectionView.frame)];
  float size = ([[UIScreen mainScreen] bounds].size.width - 15*4)/3;
  self.collectionViewCellSize  = CGSizeMake(size, size);
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
  static NSString *identifier = @"causesCollectionViewCell";
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  cell.cause = self.results[indexPath.item];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  /*
   if([collectionView isEqual:_causesCollectionView])
   {
   UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
   LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
   [self.navigationController pushViewController:vc animated:YES];  }
   else
   {
   UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
   LCSingleInterestVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
   [self.navigationController pushViewController:vc animated:YES];
   }
   */
}

@end
