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
}


-(IBAction)followButtonTapped:(id)sender
{
}


@end
