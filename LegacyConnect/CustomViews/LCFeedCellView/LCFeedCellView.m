//
//  feedCellView.m
//  LegacyConnect
//
//  Created by User on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedCellView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+TimeAgo.h"

@implementation LCFeedCellView
@synthesize delegate, feedObject, moreButton;

- (void)setData :(LCFeed *)feed forPage :(NSString *)pageType
{
  self.feedObject = feed;
  NSString  *userName = [NSString stringWithFormat:@"%@ %@",
                         [LCUtilityManager performNullCheckAndSetValue:feed.firstName],
                         [LCUtilityManager performNullCheckAndSetValue:feed.lastName]];
  NSString *cause = [LCUtilityManager performNullCheckAndSetValue:feed.interestName];
  NSString *time_ = [LCUtilityManager performNullCheckAndSetValue:feed.createdAt];
  NSString *thanks_ = [LCUtilityManager performNullCheckAndSetValue:feed.likeCount];
  NSString *comments_ = [LCUtilityManager performNullCheckAndSetValue:feed.commentCount];
  
  //set profile pic
  [profilePic sd_setImageWithURL:[NSURL URLWithString:feed.avatarURL] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
  profilePic.clipsToBounds = YES;
  
  //set user name
  NSMutableAttributedString * userNameAttributtedString = [[NSMutableAttributedString alloc] initWithString:userName];
  NSRange tagRangeUserName = NSMakeRange(0, userName.length);
  [userNameAttributtedString addAttributes:@{
                                     NSFontAttributeName : [UIFont fontWithName:@"Gotham-Medium" size:13],
                                     } range:NSMakeRange(0, userNameAttributtedString.length)];
  
  NSMutableArray *userNameLabelTagsWithRanges = [[NSMutableArray alloc] init];
  NSDictionary *dic_user = [[NSDictionary alloc] initWithObjectsAndKeys:feed.userID, @"id", @"cause", @"text", kFeedTagTypeUser, @"type", [NSValue valueWithRange:tagRangeUserName], @"range", nil];
  [userNameLabelTagsWithRanges addObject:dic_user];
  usernameLabel.tagsArray  = userNameLabelTagsWithRanges;
  [usernameLabel setAttributedText:userNameAttributtedString];
  __weak typeof(self) weakSelf = self;
  usernameLabel.nameTagTapped = ^(int index) {
    [weakSelf.delegate tagTapped:dic_user];
  };
  
  //if photo post or just plain text post
  NSString *typeString = @"Added a Photo in ";
  if ([feed.postType isEqualToString:@"0"])//not a photopost
  {
    typeString = @"Created a Post in ";
    postPhotoHeight.constant = 0;
  }
  else
  {
    [postPhoto sd_setImageWithURL:[NSURL URLWithString:feed.image] placeholderImage:[UIImage imageNamed:@""]];
  }
  
  if ([pageType isEqualToString:kHomefeedCellID])
  {
    bottomBorderHeight.constant = 0;
  }
  else if ([pageType isEqualToString:kCommentsfeedCellID])
  {
    topBorderheight.constant = 0;
  }
  //created at a cause label
  //never ever forget to add the font attribute to the tagged label
  NSString *createsAtString = [NSString stringWithFormat:@"%@%@", typeString, cause];
  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:createsAtString];
  NSRange tagRangeCreatedAt = NSMakeRange(createsAtString.length - cause.length, cause.length);
  [attributtedString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1]
                            range:NSMakeRange(0, typeString.length)];
  [attributtedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:239/255.0 green:100/255.0 blue:77/255.0 alpha:1] range:tagRangeCreatedAt];
  [attributtedString addAttributes:@{
                                         NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:12],
                                         } range:NSMakeRange(0, attributtedString.length)];
  
  NSMutableArray *createdAtLabelTagsWithRanges = [[NSMutableArray alloc] init];
  NSDictionary *dic_createdAt = [[NSDictionary alloc] initWithObjectsAndKeys:@"test", @"id", @"cause", @"text", kFeedTagTypeCause, @"type", [NSValue valueWithRange:tagRangeCreatedAt], @"range", nil];
  [createdAtLabelTagsWithRanges addObject:dic_createdAt];
  createdLabel.tagsArray  = createdAtLabelTagsWithRanges;
  [createdLabel setAttributedText:attributtedString];
  createdLabel.nameTagTapped = ^(int index) {
    [weakSelf.delegate tagTapped:dic_createdAt];
  };
  //time label
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_.longLongValue/1000];
  NSString *timeAgo = [date timeAgo];
  [timeLabel setText:timeAgo];
  
  //thanks count label
  [thanksLabel setText:thanks_];
  //comments count label
  [commentsLabel setText:comments_];
  //post desritpion
  //never ever forget to add the font attribute to the tagged label
  NSMutableAttributedString * postDescriptionString = [[NSMutableAttributedString alloc] initWithString:feed.message];
 
  NSMutableArray *postDescriptionTagsWithRanges = [[NSMutableArray alloc] init];
  for (int i = 0; i<feed.postTags.count; i++)
  {
    NSRange tagRangePost = [feed.message rangeOfString:feed.postTags[i][@"text"]];
    NSDictionary *dic_post = [[NSDictionary alloc] initWithObjectsAndKeys:feed.postTags[i][@"id"], @"id", feed.postTags[i][@"text"], @"text", feed.postTags[i][@"type"], @"type", [NSValue valueWithRange:tagRangePost], @"range", nil];
    [postDescriptionTagsWithRanges addObject:dic_post];
    
    [postDescriptionString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:tagRangePost];
  }
  [postDescriptionString addAttributes:@{
                                        NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:13],
                                        } range:NSMakeRange(0, postDescriptionString.length)];
  postDescription.tagsArray  = postDescriptionTagsWithRanges;
  [postDescription setAttributedText:postDescriptionString];
  postDescription.nameTagTapped = ^(int index) {
    [weakSelf.delegate tagTapped:weakSelf.feedObject.postTags[index]];
  };
  
}

- (IBAction)likeAction
{
  [delegate feedCellActionWithType:kFeedCellActionLike andFeed:feedObject];
}

- (IBAction)commentAction
{
  [delegate feedCellActionWithType:kFeedCellActionComment andFeed:feedObject];
}

- (IBAction)imageFullscreenAction
{
  [delegate feedCellActionWithType:kFeedCellActionImage andFeed:feedObject];
}

- (IBAction)moreButtonAction
{
  [delegate feedCellActionWithType:kFeedCellActionMore andFeed:feedObject];
}

/* use thi code if need to get the view by code
-  (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
     
  }
  return self;
}

-(void)arrangeSelfForData :(NSDictionary *)dic forWidth:(float)width_ forPage :(NSString *)pageType
{
  //pagetypy <<1 for home page feeds>>  <<>2 for comments page feed>

  float cellMargin_x = 15, cellMargin_y = 8;
  float dp_im_hight = 60;
  float in_margin = 10;
  float favWidth = 5;
  float cellSpacing_height  = 5;
  UIFont *bigFont = [UIFont systemFontOfSize:15];
  UIFont *smallFont = [UIFont systemFontOfSize:12];
  float top_space = 0;

  [self setFrame:CGRectMake(0, 0,width_,0)];

  if ([pageType isEqualToString:kHomefeedCellID])//home page
  {
    UIView *celSpace = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, width_+4, cellSpacing_height)];//spacing  between cells
    celSpace.layer.borderColor = [UIColor lightTextColor].CGColor;
    celSpace.layer.borderWidth = 1;
    celSpace.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:celSpace];
    top_space+=cellSpacing_height;
  }
  top_space+=cellMargin_y;

  NSString  *userName = [dic valueForKey:@"user_name"];
  NSString *cause = [dic valueForKey:@"cause"];
  NSString *time_ = [dic valueForKey:@"time"];
  NSString *post_ = [dic valueForKey:@"post"];
  NSString *thanks_ = [dic valueForKey:@"thanks"];
  NSString *comments_ = [dic valueForKey:@"comments"];
  NSString *type_ = @"Created a Post";
  
  if ([[dic valueForKey:@"type"] intValue] == 2)
  {
    type_ = @"Added a Photo";
  }

  UIImageView *dp_view = [[UIImageView alloc]initWithFrame:CGRectMake(cellMargin_x, top_space, dp_im_hight, dp_im_hight)];
  dp_view.layer.cornerRadius = dp_view.frame.size.width/2;
  dp_view.clipsToBounds = YES;
  [dp_view setImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
  [self addSubview:dp_view];

  UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(dp_view.frame.origin.x + dp_view.frame.size.width + cellMargin_x, top_space, self.frame.size.width - 2*cellMargin_x - dp_view.frame.size.width  - favWidth, 0)];
  [self addSubview:infoLabel];
  infoLabel.numberOfLines = 0;


  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:@""];
  //name
  NSAttributedString *name_attr = [[NSAttributedString alloc] initWithString : userName
                                                  attributes : @{
                                                                 NSFontAttributeName : bigFont,
                                                                 NSForegroundColorAttributeName : [UIColor blackColor],
                                                                 }];
  [attributtedString appendAttributedString:name_attr];

  NSAttributedString *type_attr = [[NSAttributedString alloc] initWithString : [NSString stringWithFormat:@" %@\n",type_]
                                                  attributes : @{
                                                                 NSFontAttributeName : bigFont,
                                                                 NSForegroundColorAttributeName : [UIColor grayColor],
                                                                 }];
  [attributtedString appendAttributedString:type_attr];

  //cause
  NSAttributedString *cause_attr = [[NSAttributedString alloc] initWithString : [NSString stringWithFormat:@"%@",cause]
                                                   attributes : @{
                                                                  NSFontAttributeName : bigFont,
                                                                  NSForegroundColorAttributeName : [UIColor redColor],
                                                                  }];
  [attributtedString appendAttributedString:cause_attr];
  [infoLabel setAttributedText:attributtedString];


  CGRect rect = [attributtedString boundingRectWithSize:CGSizeMake(infoLabel.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
  [infoLabel setFrame:CGRectMake(infoLabel.frame.origin.x, infoLabel.frame.origin.y, infoLabel.frame.size.width, rect.size.height)];

  UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(infoLabel.frame.origin.x, infoLabel.frame.origin.y + infoLabel.frame.size.height + 5, infoLabel.frame.size.width, smallFont.pointSize)];
  [self addSubview:timeView];

  UIImageView *clockImView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, timeView.frame.size.height, timeView.frame.size.height)];
  clockImView.image = [UIImage imageNamed:@"clock.jpg"];
  [timeView addSubview:clockImView];

  UILabel *time_label = [[UILabel alloc]initWithFrame:CGRectMake(clockImView.frame.size.width + 5, 0, timeView.frame.size.width - clockImView.frame.size.width - 5, timeView.frame.size.height)];
  time_label.font = smallFont;
  time_label.text = time_;
  time_label.textColor = [UIColor grayColor];
  [timeView addSubview:time_label];

  if (timeView.frame.size.height + timeView.frame.origin.y>dp_view.frame.size.height + dp_view.frame.origin.y)
  {
    top_space=timeView.frame.size.height + timeView.frame.origin.y + in_margin;
  }
  else
  {
    top_space=dp_view.frame.size.height + dp_view.frame.origin.y+in_margin;
  }

  UILabel *postLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellMargin_x, top_space, self.frame.size.width - 2*cellMargin_x - favWidth, 0)];
  [self addSubview:postLabel];
  postLabel.numberOfLines = 0;

  NSMutableAttributedString * post_attributtedString = [[NSMutableAttributedString alloc] initWithString:post_ attributes : @{
                                                                                                              NSFontAttributeName : bigFont,
                                                                                                              NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                                              }];
  [postLabel setAttributedText:post_attributtedString];

  rect = [post_attributtedString boundingRectWithSize:CGSizeMake(postLabel.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
  [postLabel setFrame:CGRectMake(postLabel.frame.origin.x, postLabel.frame.origin.y, postLabel.frame.size.width, rect.size.height)];

  top_space+=postLabel.frame.size.height + in_margin;

  if ([[dic valueForKey:@"type"] intValue] == 2)//photo
  {
    UIImageView *statusPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(cellMargin_x, top_space, self.frame.size.width - 2*cellMargin_x, 100)];
    [statusPhoto setImage:[UIImage imageNamed:@"photoPost_dummy.png"]];
    [self addSubview:statusPhoto];
    top_space += statusPhoto.frame.size.height + in_margin;
    UIButton *im_button = [[UIButton alloc] initWithFrame:statusPhoto.frame];
    [self addSubview:im_button];
    [im_button addTarget:self action:@selector(imageFullscreenAction) forControlEvents:UIControlEventTouchUpInside];
  }
  else
  {
    UIView *thinLine = [[UIView alloc]initWithFrame:CGRectMake(0, top_space, self.frame.size.width, 1)];
    [self addSubview:thinLine];
    [thinLine setBackgroundColor:[UIColor lightGrayColor]];
    top_space += thinLine.frame.size.height;
  }

  //bottom row
  float bot_row_hight = 40;
  float bot_IC_hight = 30;
  float bot_labe_width = 90;

  UIView * botRow = [[UIView alloc] initWithFrame:CGRectMake(cellMargin_x, top_space, self.frame.size.width - 2*cellMargin_x, bot_row_hight)];
  [self addSubview:botRow];
  UIImageView *likeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (bot_row_hight - bot_IC_hight)/2, bot_IC_hight, bot_IC_hight)];
  [likeIcon setImage:[UIImage imageNamed:@"heart_dummy.png"]];
  [botRow addSubview:likeIcon];

  UIButton *likeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bot_IC_hight, bot_row_hight)];
  likeButton.center = likeIcon.center;
  [botRow addSubview:likeButton];
//  [likeButton setBackgroundColor:[UIColor purpleColor]];
  [likeButton addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];

  UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(bot_row_hight + 10, (bot_row_hight - bot_IC_hight)/2, bot_IC_hight, bot_IC_hight)];
  [commentIcon setImage:[UIImage imageNamed:@"comment_dummy.png"]];
  [botRow addSubview:commentIcon];

  UIButton *commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bot_IC_hight, bot_row_hight)];
  commentButton.center = commentIcon.center;
  [botRow addSubview:commentButton];
//  [commentButton setBackgroundColor:[UIColor purpleColor]];
  [commentButton addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];

  UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(botRow.frame.size.width - bot_labe_width, 0, bot_labe_width, botRow.frame.size.height)];
  commentsLabel.font = smallFont;
  [commentsLabel setText:[NSString stringWithFormat:@"%@ COMMENTS", comments_]];
  [botRow addSubview:commentsLabel];
  [commentsLabel setTextAlignment:NSTextAlignmentCenter];

  UILabel *thanksLabel = [[UILabel alloc] initWithFrame:CGRectMake(botRow.frame.size.width - bot_labe_width*2, 0, bot_labe_width, botRow.frame.size.height)];
  thanksLabel.font = smallFont;
  [thanksLabel setText:[NSString stringWithFormat:@"%@ THANKS", thanks_]];
  [botRow addSubview:thanksLabel];
  [thanksLabel setTextAlignment:NSTextAlignmentCenter];

  top_space+=botRow.frame.size.height;

  if ([pageType isEqualToString:kCommentsfeedCellID])//comments page
  {
    UIView *celSpace = [[UIView alloc]initWithFrame:CGRectMake(-2, top_space, width_+4, cellSpacing_height)];//spacing  between cells
    celSpace.layer.borderColor = [UIColor lightTextColor].CGColor;
    celSpace.layer.borderWidth = 1;
    celSpace.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:celSpace];
    top_space+=cellSpacing_height;
  }
  top_space+=cellMargin_y;

  [self setFrame:CGRectMake(0, 0, self.frame.size.width, top_space)];
}
 */



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
