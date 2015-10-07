//
//  LCInterestsTableViewCell.m
//  LegacyConnect
//
//  Created by Vishnu on 9/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCInterestsTableViewCell.h"

@implementation LCInterestsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInterest:(LCInterest *)interest
{
  _interest = interest;
  [_interestImageView sd_setImageWithURL:[NSURL URLWithString:interest.logoURLSmall] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  _interestNameLabel.text = [NSString stringWithFormat:@"%@ ",interest.name];
  _interestFollowersCountLabel.text = [NSString stringWithFormat:@"%@ supporters",interest.followers];
}


-(IBAction)followButtonTapped:(id)sender
{
  
}


@end
