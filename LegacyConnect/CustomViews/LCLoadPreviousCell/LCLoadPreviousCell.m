//
//  LCLoadPreviousCell.m
//  LegacyConnect
//
//  Created by qbuser on 16/10/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCLoadPreviousCell.h"

@implementation LCLoadPreviousCell

- (void)awakeFromNib {
  [loadMorebtn setHidden:NO];
  [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)loadPreviousButtontapped:(id)sender
{
  [loadMorebtn setHidden:YES];
  [MBProgressHUD showHUDAddedTo:self animated:YES];
  if (self.loadPrevousAction) {
    self.loadPrevousAction(sender);
  }
}

@end
