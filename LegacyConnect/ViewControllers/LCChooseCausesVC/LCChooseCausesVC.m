//
//  LCChooseCausesVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseCausesVC.h"
#import "LCChooseCausesCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface LCChooseCausesVC ()
{
  NSMutableArray *selectedCauses;
  NSMutableArray *selectedInterests;
}
@end

@implementation LCChooseCausesVC

- (void)viewDidLoad {
  [super viewDidLoad];
  selectedCauses = [[NSMutableArray alloc] init];
  selectedInterests = [[NSMutableArray alloc] init];
  self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
  self.userImageView.clipsToBounds = YES;
  NSString *urlString = [NSString stringWithFormat:@"%@?type=normal",[LCDataManager sharedDataManager].avatarUrl];
  [_userImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  if([collectionView isEqual:_interestsCollectionView])
    return 10;
  else
    return 50;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if([collectionView isEqual:_interestsCollectionView])
  {
    static NSString *cellIdentifier = @"interestsCollectionViewCell";
    
    LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
      NSArray *cells =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCChooseCausesCollectionViewCell class]) owner:nil options:nil];
      cell=cells[0];
    }
    if([selectedInterests containsObject:indexPath])
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
    if([selectedCauses containsObject:indexPath])
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
    if([selectedCauses containsObject:indexPath])
    {
      [selectedCauses removeObject:indexPath];
    }
    else
    {
      [selectedCauses addObject:indexPath];
    }
    [self.causesCollectionView reloadData];
  }
  else
  {
    if([selectedInterests containsObject:indexPath])
    {
      [selectedInterests removeObject:indexPath];
    }
    else
    {
      [selectedInterests addObject:indexPath];
    }
    [self.interestsCollectionView reloadData];
  }
}

@end
