//
//  LCOnboardCauseSearchVC.m
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardCauseSearchVC.h"
#import "LCChooseCausesCollectionViewCell.h"

@interface LCOnboardCauseSearchVC ()
{
  NSArray *causesArray;
  NSTimer *searchTimer;
}
@end

@implementation LCOnboardCauseSearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection view delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return causesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"LCOnboardingChooseInterestCVC";
   LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  if (cell == nil)
  {
    NSArray *cells =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCChooseCausesCollectionViewCell class]) owner:nil options:nil];
    cell=cells[0];
  }
  cell.cause = [causesArray objectAtIndex:indexPath.row];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  cell.selected = cell.selected ? NO : YES;
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
    // remove all objects from causes array.
  }
  else
  {
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchRequest:) userInfo:searchText repeats:NO];
  }
}


-(void) searchRequest:(NSTimer*)sender
{
  // Call search API and reload
}



@end
