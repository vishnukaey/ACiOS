//
//  LCOnboardCauseSearchVC.m
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardCauseSearchVC.h"
#import "LCChooseCausesCollectionViewCell.h"
#import "LCOnboardingHelper.h"

@interface LCOnboardCauseSearchVC ()
{
  NSMutableArray *causesArray;
  NSTimer *searchTimer;
}
@end

@implementation LCOnboardCauseSearchVC

- (void)viewDidLoad
{
  [super viewDidLoad];
  causesArray = [[NSMutableArray alloc] init];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - collection view delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
  return [(LCInterest*)causesArray[section] causes].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return causesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"LCChooseCausesCollectionViewCell";
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  if (cell == nil)
  {
    NSArray *cells =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCChooseCausesCollectionViewCell class]) owner:nil options:nil];
    cell=cells[0];
  }
  cell.cause = [(LCInterest*)causesArray[indexPath.section] causes][indexPath.row];
  return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  UICollectionReusableView *reusableview = nil;
  
  if (kind == UICollectionElementKindSectionHeader)
  {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
//    NSString *title = [[NSString alloc]initWithFormat:@"%@",@"sample Text"];
    reusableview = headerView;
  }
  return reusableview;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  if(cell.selected)
  {
    [LCOnboardingHelper addCause:cell.cause andInterest:causesArray[indexPath.section]];
//    [cell setSelected:NO];
  }
  else
  {
    [LCOnboardingHelper addCause:cell.cause andInterest:causesArray[indexPath.section]];
//    [cell setSelected:YES];
  }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  if (searchTimer)
  {
    if ([searchTimer isValid]) { [searchTimer invalidate]; }
    searchTimer = nil;
  }
  if(searchBar.text.length == 0 || searchText == nil)
  {
    [causesArray removeAllObjects];
  }
  else
  {
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchRequest:) userInfo:searchText repeats:NO];
  }
}


-(void) searchRequest:(NSTimer*)sender
{
  [LCSearchAPIManager searchCausesWithInterestForSearchText:_searchBar.text lastId:@"" withSuccess:^(id response) {
    [causesArray removeAllObjects];
    [causesArray addObjectsFromArray:response];
    [_causesCollectionView reloadData];
  } andfailure:^(NSString *error) {
  }];
}



@end
