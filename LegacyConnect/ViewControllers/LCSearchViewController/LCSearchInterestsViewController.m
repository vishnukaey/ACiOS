//
//  LCSearchInterestsViewController.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCSearchInterestsViewController.h"
#import "LCChooseInterestCVC.h"

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
  [LCAPIManager getInterestsSearchResultsWithSearchKey:_searchKey withFastId:[(LCInterest*)[self.results lastObject] interestID] success:^(id response) {
    BOOL hasMoreData = [(NSArray*)response count] >= 20;
    [self didFetchNextResults:response haveMoreData:hasMoreData];
  } andfailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.noResultsView = [self getNOResultLabel];
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
