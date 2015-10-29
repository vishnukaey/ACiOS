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
  if(!_causeSupportButton.selected)
  {
    [_causeSupportButton setSelected:YES];
    [LCAPIManager supportCause:_cause.causeID withSuccess:^(id response) {
      _cause.isSupporting =YES;
    } andFailure:^(NSString *error) {
      [_causeSupportButton setSelected:NO];
    }];
  }
  else
  {
    [_causeSupportButton setSelected:NO];
    [LCAPIManager unsupportCause:_cause.causeID withSuccess:^(id response) {
      _cause.isSupporting =NO;
    } andFailure:^(NSString *error) {
      [_causeSupportButton setSelected:YES];
    }];
  }
}



@end
