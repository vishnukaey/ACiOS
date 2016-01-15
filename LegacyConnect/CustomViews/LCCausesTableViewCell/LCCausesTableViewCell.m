//
//  LCCausesTableViewCell.m
//  LegacyConnect
//
//  Created by Vishnu on 9/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCausesTableViewCell.h"

@implementation LCCausesTableViewCell

- (void)awakeFromNib
{
  [_causeSupportButton setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
  _causeSupportButton.layer.cornerRadius = 5.0;
  _causeSupportButton.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
  _causeSupportButton.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCause:(LCCause *)cause
{
  _cause = cause;
  [self.imageContainer setBackgroundColor:[UIColor clearColor]];
  [self.imageContainer.layer setCornerRadius:5.0f];
  [self.imageContainer.layer setBorderColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor];
  [self.imageContainer.layer setBorderWidth:1];
  [_causeImageView sd_setImageWithURL:[NSURL URLWithString:cause.logoURLSmall] placeholderImage:nil];
  _causeNameLabel.text = [NSString stringWithFormat:@"%@",cause.name];
  _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%@ Followers",cause.supporters];
  if(_cause.isSupporting)
  {
    [_causeSupportButton setSelected:YES];
  }
  else
  {
    [_causeSupportButton setSelected:NO];
  }
}


-(IBAction)supportButtonTapped:(id)sender
{
  _causeSupportButton.userInteractionEnabled = NO;
  if(!_causeSupportButton.selected)
  {
    _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%d Followers",[_cause.supporters intValue]+1];
    [_causeSupportButton setSelected:YES];
    [LCThemeAPIManager supportCause:_cause withSuccess:^(id response) {
      _cause.isSupporting =YES;
      _cause.supporters = [NSString stringWithFormat:@"%d",[_cause.supporters intValue]+1];
      _causeSupportButton.userInteractionEnabled = YES;
    } andFailure:^(NSString *error) {
      [_causeSupportButton setSelected:NO];
      _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%@ Followers",_cause.supporters];
      _causeSupportButton.userInteractionEnabled = YES;
    }];
  }
  else
  {
    _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%d Followers",[_cause.supporters intValue]-1];
    [_causeSupportButton setSelected:NO];
    [LCThemeAPIManager unsupportCause:_cause withSuccess:^(id response) {
      _causeSupportButton.userInteractionEnabled = YES;
      _cause.isSupporting = NO;
      _cause.supporters = [NSString stringWithFormat:@"%d",[_cause.supporters intValue]-1];
    } andFailure:^(NSString *error) {
      _causeSupportButton.userInteractionEnabled = YES;
      _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%@ Followers",_cause.supporters];
      [_causeSupportButton setSelected:YES];
    }];
  }

}



@end
