//
//  LCUserTableViewCell.m
//  LegacyConnect
//
//  Created by Vishnu on 9/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUserTableViewCell.h"

@implementation LCUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(LCUserDetail *)user
{
  _user = user;
  [_userImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarURL] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  _userNameLabel.text = [NSString stringWithFormat:@"%@ %@",user.firstName, user.lastName];
  _userLocationLabel.text = [NSString stringWithFormat:@"%@ ",user.location];
}


-(IBAction)addButtonTapped:(id)sender
{
  
}

@end
