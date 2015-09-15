//
//  LCChooseCausesVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseCausesVC.h"
#import "LCChooseCausesCollectionViewCell.h"
#import "LCChooseInterestCVC.h"


@interface LCChooseCausesVC ()
{
  NSMutableDictionary *selectedItems;
  NSMutableArray *causes;
  NSArray *interests;
  IBOutlet UIButton *nextButton;
}
@end

@implementation LCChooseCausesVC

- (void)viewDidLoad {
  [super viewDidLoad];
  selectedItems = [[NSMutableDictionary alloc] init];
  causes = [[NSMutableArray alloc] init];
  self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
  self.userImageView.clipsToBounds = YES;
  self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
  self.userImageView.layer.borderWidth = 3;
  nextButton.layer.cornerRadius = 5;
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  self.customNavigationHeight.constant = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
  NSString *urlString = [NSString stringWithFormat:@"%@?type=normal",[LCDataManager sharedDataManager].avatarUrl];
  [_userImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  [LCAPIManager getInterestsWithSuccess:^(NSArray *response) {
    interests = response;
    [self.interestsCollectionView reloadData];
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
}


- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  if([collectionView isEqual:_interestsCollectionView])
    return interests.count;
  else
    return causes.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if([collectionView isEqual:_interestsCollectionView])
  {
    static NSString *cellIdentifier = @"interestsCollectionViewCell";
    
    LCChooseInterestCVC *cell = (LCChooseInterestCVC*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
      NSArray *cells =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCChooseInterestCVC class]) owner:nil options:nil];
      cell=cells[0];
    }
    cell.interest = interests[indexPath.item];
    NSArray *selectedInterestIDs = [selectedItems allKeys];
    if([selectedInterestIDs containsObject:cell.interest.interestID])
    {
      [cell setCellSelected:YES];
    }
    else
    {
      [cell setCellSelected:NO];
    }
    return cell;
  }
  else
  {
    static NSString *cellIdentifier = @"causesCollectionViewCell";
    LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
   
    if (cell == nil)
    {
      NSArray *cells =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCChooseCausesCollectionViewCell class]) owner:nil options:nil];
      cell=cells[0];
    }
    cell.cause = causes[indexPath.item];
    NSArray *selectedCauseIDs = [selectedItems valueForKey:cell.cause.interestID];
    if([selectedCauseIDs containsObject:cell.cause.causeID])
    {
      [cell setCellSelected:YES];
    }
    else
    {
      [cell setCellSelected:NO];
    }
    return cell;
  }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSArray *selectedInterestIDs = [selectedItems allKeys];
  if([collectionView isEqual:_causesCollectionView])
  {
    LCCause *cause = causes[indexPath.item];
    NSMutableArray *selectedCauseIDs = [selectedItems valueForKey:cause.interestID];
    if([selectedCauseIDs containsObject:cause.causeID])
    {
      [selectedCauseIDs removeObject:cause.causeID];
    }
    else
    {
      [selectedCauseIDs addObject:cause.causeID];
    }
    [self.causesCollectionView reloadData];
  }
  else
  {
    LCInterest *interest = interests[indexPath.item];
    if([selectedInterestIDs containsObject:interest.interestID])
    {
      [selectedItems removeObjectForKey:interest.interestID];
      [causes removeObjectsInArray:interest.causes];
      [self.causesCollectionView reloadData];
      [self.interestsCollectionView reloadData];
    }
    else
    {
      NSMutableArray *selectedCauses = [[NSMutableArray alloc] init];
      [selectedItems setObject:selectedCauses forKey:interest.interestID];

      [LCAPIManager getCausesForInterestID:interest.interestID andLastCauseID:kEmptyStringValue withSuccess:^(NSArray *responses) {
        interest.causes = responses;
        [causes addObjectsFromArray:interest.causes];
        [self.causesCollectionView reloadData];
        [self.interestsCollectionView reloadData];
      } andFailure:^(NSString *error) {
        NSLog(@"%@",error);
      }];
      
    }

  }
}


-(IBAction) nextButtonTapped:(id)sender
{
  NSArray *selectedInterestIDs = [selectedItems allKeys];
  NSArray *selectedCauseIDs = [selectedItems allValues];
  [LCAPIManager saveCauses:selectedCauseIDs andInterests:selectedInterestIDs ofUser:[LCDataManager sharedDataManager].userID   withSuccess:^(id response) {
    [self performSegueWithIdentifier:@"connectFriends" sender:self];
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
}

@end
