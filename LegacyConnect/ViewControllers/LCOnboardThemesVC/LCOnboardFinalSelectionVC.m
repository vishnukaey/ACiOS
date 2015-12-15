//
//  LCOnboardFinalSelectionVC.m
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardFinalSelectionVC.h"
#import "LCChooseCausesCollectionViewCell.h"
#import "LCOnboardCausesVC.h"

#pragma mark - LCCausesHeaderReusableView class
@interface LCCausesHeaderReusableView : UICollectionReusableView
  @property (weak, nonatomic) IBOutlet UILabel *interestName;
  @property (weak, nonatomic) IBOutlet UIButton *showAllButton;
@end

@implementation LCCausesHeaderReusableView
@end

@interface LCOnboardFinalSelectionVC ()

@end

@implementation LCOnboardFinalSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  self.collectionView.allowsMultipleSelection = YES;
  [self getCauses];
}

- (void) viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:NO ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) getCauses {
  
  NSArray *interestArray = @[@"1", @"2", @"3"];
  
  [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
  [LCThemeAPIManager getCausesForSetOfInterests:interestArray withSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.collectionView animated:YES];
    self.interestArray = response;
    [self.collectionView reloadData];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.collectionView animated:YES];
  }];
}

- (IBAction)showAllAction:(UIButton*)sender {

  NSInteger section = sender.tag;
  LCInterest *interest = self.interestArray[section];
  
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
  LCOnboardCausesVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCOnboardCausesVC"];
  vc.interest = interest;
  [self.navigationController pushViewController:vc animated:YES];;
}

#pragma CollectionView Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return self.interestArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

  LCInterest *interest = self.interestArray[section];
  return interest.causes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  static NSString *identifier = @"causesCell";
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  
  LCInterest *interest = self.interestArray[indexPath.section];
  cell.cause = interest.causes[indexPath.item];
  
  return cell;
  
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  [cell.selectionButton setSelected:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  [cell.selectionButton setSelected:NO];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
  CGSize size = CGSizeMake(105, 140);
  return size;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  if (kind == UICollectionElementKindSectionHeader) {
    
    LCCausesHeaderReusableView *reusableview =(LCCausesHeaderReusableView*)[collectionView
                                                                            dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:@"headerCell"
                                                                            forIndexPath:indexPath];
    LCInterest *interest = self.interestArray[indexPath.section];
    reusableview.interestName.text = interest.name;
    reusableview.showAllButton.tag = indexPath.section;
    return reusableview;
  }
  return nil;
}

@end
