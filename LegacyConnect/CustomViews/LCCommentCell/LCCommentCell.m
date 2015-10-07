//
//  TableViewCell.m
//  LegacyConnect
//
//  Created by User on 8/10/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCommentCell.h"

@implementation LCCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData :(NSDictionary *)dic
{
  NSString  *userName = [dic valueForKey:@"user_name"];
  NSString *time_ = [dic valueForKey:@"time"];
  NSString *comments_ = [dic valueForKey:@"comment"];
  
  profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
  profilePic.clipsToBounds = YES;
  [profilePic setImage:[UIImage imageNamed:@"userProfilePic"]];
  [timeLabel setText:time_];
  [commentLabel setText:comments_];
  [userNameLabel setText:userName];
  
}

@end
