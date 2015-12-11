//
//  LCAllInterestVC.m
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCAllInterestVC.h"
#import "LCSingleInterestVC.h"
#import "LCCommunityInterestCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LCAllInterestVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  //mine interst api call
  [LCThemeAPIManager getInterestsWithSuccess:^(NSArray *response) {
    interestsMine = response;
    [self showMyInterests];
  } andFailure:^(NSString *error) {
  }];
  
  //all interests api call
  [LCThemeAPIManager getInterestsWithSuccess:^(NSArray *response) {
    interestsAll = response;
  } andFailure:^(NSString *error) {
  }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = false;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [appdel.menuButton setHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}



#pragma mark - setUpFunctions
- (void)showMyInterests
{
  selectedDataArray = interestsMine;
  [interestsCollection reloadData];
}

-(void)showAllInterests
{
  selectedDataArray = interestsAll;
  [interestsCollection reloadData];
}

#pragma mark - button Actions
- (IBAction)toggleMineORAll:(UIButton *)sender
{
  if (sender.tag == 1)//mine
  {
    [self showMyInterests];
  }
  else//all--tag-2
  {
    [self showAllInterests];
  }
}

#pragma mark - collection view delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return selectedDataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"LCInterestCell";
  LCCommunityInterestCell *cell = (LCCommunityInterestCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  if (cell == nil)
  {
    NSArray *cells =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCCommunityInterestCell class]) owner:nil options:nil];
    cell=cells[0];
  }
  LCInterest *interstObj = [selectedDataArray objectAtIndex:indexPath.row];
  cell.interestNameLabel.text = interstObj.name;
  
  [cell.interestIcon sd_setImageWithURL:[NSURL URLWithString:interstObj.logoURLLarge] placeholderImage:nil];
  
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
  LCSingleInterestVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleInterestVC"];
  [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
