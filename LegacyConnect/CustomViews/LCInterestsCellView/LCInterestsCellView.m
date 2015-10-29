//
//  LCInterestsCellView.m
//  LegacyConnect
//
//  Created by Akhil K C on 9/28/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCInterestsCellView.h"

@implementation LCInterestsCellView

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData: (LCInterest *) interest {
  
  _interestNameLabel.text = [LCUtilityManager performNullCheckAndSetValue:interest.name];
  
  _interestFollowLabel.text = [NSString stringWithFormat:@"Followed by %ld people",
                                   (long)[interest.followers integerValue]];
  [_interestsBG sd_setImageWithURL:[NSURL URLWithString:interest.logoURLLarge]
                      placeholderImage:nil];
}

@end
