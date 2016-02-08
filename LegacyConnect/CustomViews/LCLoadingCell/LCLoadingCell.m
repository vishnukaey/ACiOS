//
//  LCLoadingCell.m
//  LegacyConnect
//
//  Created by qbuser on 05/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCLoadingCell.h"

static NSString *kLoadingCellId = @"LoadingCell";


@implementation LCLoadingCell

+ (NSString*)getFeedCellidentifier
{
  return kLoadingCellId;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
