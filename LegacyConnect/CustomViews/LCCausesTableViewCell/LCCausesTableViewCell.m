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
  [_causeImageView sd_setImageWithURL:[NSURL URLWithString:cause.logoURLSmall] placeholderImage:nil];
  _causeNameLabel.text = [NSString stringWithFormat:@"%@",cause.name];
  _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%@ Supporters",cause.supporters];
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
    _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%d Supporters",[_cause.supporters intValue]+1];
    [_causeSupportButton setSelected:YES];
    [LCAPIManager supportCause:_cause.causeID withSuccess:^(id response) {
      _cause.isSupporting =YES;
      _cause.supporters = [NSString stringWithFormat:@"%d",[_cause.supporters intValue]+1];
      _causeSupportButton.userInteractionEnabled = YES;
    } andFailure:^(NSString *error) {
      [_causeSupportButton setSelected:NO];
      _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%@ Supporters",_cause.supporters];
      _causeSupportButton.userInteractionEnabled = YES;
    }];
  }
  else
  {
    _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%d Supporters",[_cause.supporters intValue]-1];
    [_causeSupportButton setSelected:NO];
    [LCAPIManager unsupportCause:_cause.causeID withSuccess:^(id response) {
      _causeSupportButton.userInteractionEnabled = YES;
      _cause.isSupporting = NO;
      _cause.supporters = [NSString stringWithFormat:@"%d",[_cause.supporters intValue]-1];
    } andFailure:^(NSString *error) {
      _causeSupportButton.userInteractionEnabled = YES;
      _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%@ Supporters",_cause.supporters];
      [_causeSupportButton setSelected:YES];
    }];
  }

}



@end
