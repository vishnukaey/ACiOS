//
//  LCLoadingCell.m
//  LegacyConnect
//
//  Created by qbuser on 05/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCLoadingCell.h"

static NSString *kLoadingCellIdentifier = @"LoadingCell";


@implementation LCLoadingCell

+ (NSString*)getFeedCellidentifier
{
  return kLoadingCellIdentifier;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
