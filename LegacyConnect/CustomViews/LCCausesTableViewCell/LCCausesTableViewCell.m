//
//  LCCausesTableViewCell.m
//  LegacyConnect
//
//  Created by Vishnu on 9/7/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCausesTableViewCell.h"

@implementation LCCausesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCause:(LCCause *)cause
{
  _cause = cause;
  [_causeImageView sd_setImageWithURL:[NSURL URLWithString:cause.logoURLSmall] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  _causeNameLabel.text = [NSString stringWithFormat:@"%@",cause.name];
  _causeSupportersCountLabel.text = [NSString stringWithFormat:@"%@ supporters",cause.supporters];
}


-(IBAction)supportButtonTapped:(id)sender
{
  
}



@end
