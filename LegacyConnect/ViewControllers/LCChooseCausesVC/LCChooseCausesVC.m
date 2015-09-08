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
  NSMutableArray *selectedCauses;
  NSMutableArray *selectedInterests;
  NSMutableArray *causes;
  NSArray *interests;
}
@end

@implementation LCChooseCausesVC

- (void)viewDidLoad {
  [super viewDidLoad];
  selectedCauses = [[NSMutableArray alloc] init];
  selectedInterests = [[NSMutableArray alloc] init];
  causes = [[NSMutableArray alloc] init];
  self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
  self.userImageView.clipsToBounds = YES;
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
    
    if([selectedInterests containsObject:cell.interest])
    {
      cell.selectionButton.selected =YES;
    }
    else
    {
      cell.selectionButton.selected=NO;
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
    
    if([selectedCauses containsObject:cell.cause])
    {
      cell.selectionButton.selected =YES;
    }
    else
    {
      cell.selectionButton.selected=NO;
    }
    return cell;
  }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  if([collectionView isEqual:_causesCollectionView])
  {
    LCCause *cause = causes[indexPath.item];
    if([selectedCauses containsObject:cause])
    {
      [selectedCauses removeObject:cause];
    }
    else
    {
      [selectedCauses addObject:cause];
    }
    [self.causesCollectionView reloadData];
  }
  else
  {
    LCInterest *interest = interests[indexPath.item];
    if([selectedInterests containsObject:interest])
    {
      [selectedInterests removeObject:interest];
      [causes removeObjectsInArray:interest.causes];
      [self.causesCollectionView reloadData];
      [self.interestsCollectionView reloadData];
    }
    else
    {
      [selectedInterests addObject:interest];

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
  [LCAPIManager saveCauses:selectedCauses ofUser:[LCDataManager sharedDataManager].userID   withSuccess:^(id response) {
    NSLog(@"%@",response);
    [self performSegueWithIdentifier:@"connectFriends" sender:self];
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
  
}

@end
