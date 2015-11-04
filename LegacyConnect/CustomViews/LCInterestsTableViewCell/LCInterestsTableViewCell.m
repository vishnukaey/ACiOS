//
//  LCInterestsTableViewCell.m
//  LegacyConnect
//
//  Created by Vishnu on 9/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCInterestsTableViewCell.h"

@implementation LCInterestsTableViewCell

- (void)awakeFromNib
{
  [_interestFollowButton setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
  _interestFollowButton.layer.cornerRadius = 5.0;
  _interestFollowButton.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
  _interestFollowButton.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInterest:(LCInterest *)interest
{
  _interest = interest;
  [_interestImageView sd_setImageWithURL:[NSURL URLWithString:interest.logoURLSmall] placeholderImage:nil];
  _interestNameLabel.text = [NSString stringWithFormat:@"%@ ",interest.name];
  _interestFollowersCountLabel.text = [NSString stringWithFormat:@"%@ Followers",interest.followers];
  if(_interest.isFollowing)
  {
    [_interestFollowButton setSelected:YES];
  }
  else
  {
    [_interestFollowButton setSelected:NO];
  }
}


-(IBAction)followButtonTapped:(id)sender
{
  _interestFollowButton.userInteractionEnabled = NO;
  if(!_interestFollowButton.selected)
  {
    _interestFollowersCountLabel.text = [NSString stringWithFormat:@"%d Followers",[_interest.followers intValue]+1];
    [_interestFollowButton setSelected:YES];
    [LCAPIManager followInterest:_interest.interestID withSuccess:^(id response) {
      _interest.isFollowing =YES;
      _interest.followers = [NSString stringWithFormat:@"%d",[_interest.followers intValue]+1];
      _interestFollowButton.userInteractionEnabled = YES;
    } andFailure:^(NSString *error) {
      [_interestFollowButton setSelected:NO];
      _interestFollowersCountLabel.text = [NSString stringWithFormat:@"%@ Followers",_interest.followers];
      _interestFollowButton.userInteractionEnabled = YES;
    }];
  }
  else
  {
    _interestFollowersCountLabel.text = [NSString stringWithFormat:@"%d Followers",[_interest.followers intValue]-1];
    [_interestFollowButton setSelected:NO];
    [LCAPIManager unfollowInterest:_interest.interestID withSuccess:^(id response) {
      _interestFollowButton.userInteractionEnabled = YES;
      _interest.isFollowing = NO;
      _interest.followers = [NSString stringWithFormat:@"%d",[_interest.followers intValue]-1];
    } andFailure:^(NSString *error) {
      _interestFollowButton.userInteractionEnabled = YES;
      _interestFollowersCountLabel.text = [NSString stringWithFormat:@"%@ Followers",_interest.followers];
      [_interestFollowButton setSelected:YES];
    }];
  }
}


@end
