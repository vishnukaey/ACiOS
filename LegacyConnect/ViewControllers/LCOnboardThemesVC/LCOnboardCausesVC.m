//
//  LCOnboardCausesVC.m
//  LegacyConnect
//
//  Created by Akhil K C on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardCausesVC.h"
#import "LCChooseCausesCollectionViewCell.h"

#pragma mark - LCInviteFromContactsCell class
@interface LCOnboardCausesViewCell : UICollectionViewCell

  @property (weak, nonatomic) IBOutlet UIImageView *causeImage;
  @property (weak, nonatomic) IBOutlet UILabel *causeName;
  @property (weak, nonatomic) IBOutlet UIButton *followCauseButton;

@end

@implementation LCOnboardCausesViewCell
@end

@interface LCOnboardCausesVC ()

@end

@implementation LCOnboardCausesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//  float size = ([[UIScreen mainScreen] bounds].size.width - 15*4)/3;
//  causesCollectionView.collectionViewCellSize  = CGSizeMake(size, size);
//  causesCollectionView.collectionViewCellSize = CGSizeMake(size, size + 20);
//  causesCollectionView.collec
  
//  float size = ([[UIScreen mainScreen] bounds].size.width - 15*4)/3;
  self.collectionViewCellSize  = CGSizeMake(105, 135);
  [self startFetchingResults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startFetchingResults
{
  [super startFetchingResults];
  [LCAPIManager getCausesForInterestID:@"1" andLastCauseID:nil withSuccess:^(NSArray *responses) {
    
    BOOL hasMoreData = [(NSArray*)responses count] >= 10;
    [self didFetchNextResults:responses haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  
  [LCAPIManager getCausesForInterestID:@"" andLastCauseID:[(LCCause*)[self.results lastObject] causeID] withSuccess:^(NSArray *responses) {
    
    BOOL hasMoreData = [(NSArray*)responses count] >= 10;
    [self didFetchNextResults:responses haveMoreData:hasMoreData];
  } andFailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}



#pragma CollectionView Delegates
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//  
//  return 8;
//  
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
//  static NSString *identifier = @"causesCell";
//  
//  LCOnboardCausesViewCell *cell = (LCOnboardCausesViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//  
//  cell.causeName.text = @"name";
//  cell.causeImage.image = [UIImage imageNamed:@"userProfilePic"];
//  [cell.followCauseButton setSelected:YES];

  LCCOLLECTIONVIEW_cellForItemAtIndexPath
  
  static NSString *identifier = @"causesCollectionViewCell";
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  cell.cause = self.results[indexPath.item];
  
  return cell;
  
}

//- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//  float size = ([[UIScreen mainScreen] bounds].size.width - 8*4)/3;
//  return CGSizeMake(size, size);  // will be w120xh100 or w190x100
//  // if the width is higher, only one image will be shown in a line
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//  return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
//}

@end
