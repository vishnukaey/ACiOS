//
//  TableViewCell.h
//  LegacyConnect
//
//  Created by User on 8/10/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCCommentCell : UITableViewCell
{
  IBOutlet UIImageView *profilePic;
  IBOutlet UILabel *userNameLabel, *timeLabel, *commentLabel;
}

@property (nonatomic, strong) LCComment * comment;

- (void)setComment:(LCComment *)comment;

@end
