//
//  LCCollectionViewController.m
//  LegacyConnect
//
//  Created by qbuser on 03/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCCollectionViewController.h"
#import <Masonry.h>

@implementation LCCollectionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(!self){
    return nil;
  }
  
  [self commonInit];
  
  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if(!self){
    return nil;
  }
  
  [self commonInit];
  
  return self;
}

- (void)commonInit
{
  self->_isLoading = NO;
  self->_haveMoreData = NO;
  self->_results = [NSMutableArray new];
  self.nextPageLoaderOffset = 6;
  self.collectionViewCellInsects = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
  self.collectionViewCellSize = CGSizeMake(100.0f, 100.0f);
  self.interItemSpace = 10.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // If startFetchingResults was called before the view exist
  if(self.results.count == 0 && self.isLoading){
    [self showNoResultsLoadingView];
  }
}

- (void)resetData
{
  self->_isLoading = NO;
  self->_haveMoreData = NO;
  [self.results removeAllObjects];
  [self.collectionView reloadData];
}

#pragma mark - UICollectionView

- (void)setCollectionView:(UICollectionView *)collectionView
{
  [self.collectionView setDataSource:nil];
  [self.collectionView setDelegate:nil];
  
  self->_collectionView = collectionView;
  
  [self.collectionView setDataSource:self];
  [self.collectionView setDelegate:self];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  if(self.haveMoreData && self.nextPageLoaderCell){
    return [self.results count] + 1;
  }
  
  return [self.results count];
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  CGSize nextPageLoaderCellSize = self.nextPageLoaderCell.frame.size;
  if(indexPath.row == [self.results count] && !CGSizeEqualToSize(nextPageLoaderCellSize, CGSizeZero)){
    return nextPageLoaderCellSize;
  }
  
  return self->_collectionViewCellSize;
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return self->_collectionViewCellInsects;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return self->_interItemSpace;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.row == [self.results count]){
    return self.nextPageLoaderCell;
  }
  else if(!self.isLoading && indexPath.row >= self.results.count - self.nextPageLoaderOffset && self.haveMoreData){
    [self startFetchingNextResults];
  }
  
  return nil;

}

#pragma mark - NoResultsView

- (void)setNoResultsView:(UIView *)noResultsView
{
  NSAssert(self.collectionView, @"You have to set the collectionView first");
  
  self->_noResultsView = noResultsView;
  [self.collectionView.superview addSubview:self.noResultsView];
  
  [self.noResultsView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.collectionView);
  }];
  
  self.noResultsView.hidden = YES;
  
  // Avoid noResultsView to block touch for the refresh control
  self.noResultsView.userInteractionEnabled = NO;
}

- (void)showNoResultsView
{
  self.noResultsView.hidden = NO;
}

- (void)hideNoResultsView
{
  self.noResultsView.hidden = YES;
}

#pragma mark - NoResultsLoadingView

- (void)setNoResultsLoadingView:(UIView *)noResultsLoadingView
{
  NSAssert(self.collectionView, @"You have to set the collectionView first");
  
  self->_noResultsLoadingView = noResultsLoadingView;
  [self.collectionView.superview addSubview:self.noResultsLoadingView];
  
  [self.noResultsLoadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.collectionView);
  }];
  
  self.noResultsLoadingView.hidden = YES;
}

- (void)showNoResultsLoadingView
{
  self.noResultsLoadingView.hidden = NO;
}

- (void)hideNoResultsLoadingView
{
  self.noResultsLoadingView.hidden = YES;
}

#pragma mark - Fetch results

- (void)didFetchResults:(NSArray *)results haveMoreData:(BOOL)haveMoreData
{
  self->_isLoading = NO;
  [self endRefreshing];
  [self hideNoResultsLoadingView];
  
  [self.results removeAllObjects];
  [self.results addObjectsFromArray:results];
  
  self->_haveMoreData = haveMoreData;
  [self.collectionView reloadData];
  
  if(self.results.count == 0){
    [self showNoResultsView];
  }
}

- (void)didFetchNextResults:(NSArray *)results haveMoreData:(BOOL)haveMoreData
{
  self->_isLoading = NO;
  [self endRefreshing];
  [self hideNoResultsLoadingView];
  
  [self.results addObjectsFromArray:results];
  self->_haveMoreData = haveMoreData;
  [self.collectionView reloadData];
}

- (void)didFailedToFetchResults
{
  self->_isLoading = NO;
  [self endRefreshing];
  [self hideNoResultsLoadingView];
}

- (void)startFetchingResults
{
  self->_isLoading = YES;
  [self hideNoResultsView];
  
  if(self.results.count == 0){
    [self showNoResultsLoadingView];
  }
}

- (void)startFetchingNextResults
{
  self->_isLoading = YES;
  [self hideNoResultsView];
}

- (void)endRefreshing
{
  
}



@end
