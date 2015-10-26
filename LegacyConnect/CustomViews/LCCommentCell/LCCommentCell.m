//
//  TableViewCell.m
//  LegacyConnect
//
//  Created by User on 8/10/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCommentCell.h"
#import "NSDate+TimeAgo.h"

@implementation LCCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(LCComment *)comment
{
  profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
  profilePic.clipsToBounds = YES;
  [profilePic sd_setImageWithURL:[NSURL URLWithString:comment.avatarUrl] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  
  NSString *time_ = [LCUtilityManager performNullCheckAndSetValue:comment.createdAt];
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_.longLongValue/1000];
  NSString *timeAgo = [date timeAgo];
  [timeLabel setText:timeAgo];
  [commentLabel setText:comment.commentText];
  NSString * userName = [NSString stringWithFormat:@"%@ %@",[LCUtilityManager performNullCheckAndSetValue:comment.firstName],[LCUtilityManager performNullCheckAndSetValue:comment.lastName]] ;
  
  
//  NSMutableAttributedString * userNameAttributtedString = [[NSMutableAttributedString alloc] initWithString:userName];
//  NSRange tagRangeUserName = NSMakeRange(0, userName.length);
//  [userNameAttributtedString addAttributes:@{
//                                             NSFontAttributeName : [UIFont fontWithName:@"Gotham-Medium" size:13],
//                                             } range:NSMakeRange(0, userNameAttributtedString.length)];
//  
//  NSMutableArray *userNameLabelTagsWithRanges = [[NSMutableArray alloc] init];
//  NSDictionary *dic_user = [[NSDictionary alloc] initWithObjectsAndKeys:comment.userID, @"id", @"cause", @"text", kFeedTagTypeUser, @"type", [NSValue valueWithRange:tagRangeUserName], @"range", nil];
//  [userNameLabelTagsWithRanges addObject:dic_user];
//  usernameLabel.tagsArray  = userNameLabelTagsWithRanges;
//  [usernameLabel setAttributedText:userNameAttributtedString];
//  __weak typeof(self) weakSelf = self;
//  usernameLabel.nameTagTapped = ^(int index) {
//    weakSelf.feedCellTagAction(dic_user);
//  };

  [userNameLabel setText:userName];
}

@end
