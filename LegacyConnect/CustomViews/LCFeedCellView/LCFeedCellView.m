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

#define kNormalPostTextColor [UIColor colorWithRed:35/255.0 green:31/255.0 blue:32/255.0 alpha:1]
#define kTagsTextColor [LCUtilityManager getThemeRedColor]
#define kImageLoadingBackColor [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1.0]
#define kFeedUserTextFont [UIFont fontWithName:@"Gotham-Medium" size:13]
#define kPostInfoFont [UIFont fontWithName:@"Gotham-Book" size:13]

static NSString *kAddedAPhotoIn = @"Added a Photo in ";
static NSString *kCreatedAPostIn = @"Created a Post in ";
static NSString *kPostTypeTextOnly = @"0";

static NSString *kFeedCellIdentifier = @"LCFeedCell";

@implementation LCFeedCellView
@synthesize delegate, feedObject, moreButton;
#pragma mark - public method implementation
+ (NSString*)getFeedCellIdentifier
{
  return kFeedCellIdentifier;
}

#pragma mark - private method implementation
- (void)setProfilePic
{
  //set profile pic
  [profilePic sd_setImageWithURL:[NSURL URLWithString:self.feedObject.avatarURL] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
  profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
  profilePic.clipsToBounds = YES;
}

- (void)setFeedUserName
{
  NSString  *userName = [NSString stringWithFormat:@"%@ %@",
                         [LCUtilityManager performNullCheckAndSetValue:self.feedObject.firstName],
                         [LCUtilityManager performNullCheckAndSetValue:self.feedObject.lastName]];
  
  NSMutableAttributedString * userNameAttributtedString = [[NSMutableAttributedString alloc] initWithString:userName];
  NSRange tagRangeUserName = NSMakeRange(0, userName.length);
  [userNameAttributtedString addAttributes:@{
                                             NSFontAttributeName : kFeedUserTextFont,
                                             } range:NSMakeRange(0, userNameAttributtedString.length)];
  
  NSMutableArray *userNameLabelTagsWithRanges = [[NSMutableArray alloc] init];
  NSDictionary *dic_user = [[NSDictionary alloc] initWithObjectsAndKeys:self.feedObject.userID, @"id", @"cause", @"text", kFeedTagTypeUser, @"type", [NSValue valueWithRange:tagRangeUserName], @"range", nil];
  [userNameLabelTagsWithRanges addObject:dic_user];
  usernameLabel.tagsArray  = userNameLabelTagsWithRanges;
  [usernameLabel setAttributedText:userNameAttributtedString];
  __weak typeof(self) weakSelf = self;
  usernameLabel.nameTagTapped = ^(int index) {
    weakSelf.feedCellTagAction(dic_user);
  };
  
  //-- Milestone -- //
  [milestoneImage setHidden:![self.feedObject.isMilestone boolValue]];
}

/*!
 * This method is supposed to be call after a successful call to startFetchingNextResults.
 */
- (void)setFeedInfoDetails
{
  /*!
   * This method is supposed to be call after a successful call to startFetchingNextResults.
   */

  NSString *typeString = kAddedAPhotoIn;
  if ([self.feedObject.postType isEqualToString:kPostTypeTextOnly])
  {
    typeString = kCreatedAPostIn;
    postPhotoHeight.constant = 0;
  }
  else
  {
    [postPhoto setContentMode:UIViewContentModeScaleAspectFill];
    postPhotoHeight.constant = 200;
    [self retryLoadingFeedImage:nil];
  }
  
  
  //never ever forget to add the font attribute to the tagged label
  NSString *cause = [LCUtilityManager performNullCheckAndSetValue:self.feedObject.postToName];

  NSString *postTypeAndCause = [NSString stringWithFormat:@"%@%@", typeString, cause];
  NSString * postInfoString = postTypeAndCause;
  
  
  /*!
   * This method is supposed to be call after a successful call to startFetchingNextResults.
   */

  NSString * atString = @" at ";
  NSString *location = [LCUtilityManager performNullCheckAndSetValue:self.feedObject.location];

  if (location.length > 0) {
    NSString * atLocation = [NSString stringWithFormat:@"%@%@",atString,location];
    postInfoString = [NSString stringWithFormat:@"%@%@",postTypeAndCause,atLocation];
  }
  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:postInfoString];
  
  // -- Add Font -- //
  [attributtedString addAttributes:@{
                                     NSFontAttributeName : kPostInfoFont,
                                     } range:NSMakeRange(0, attributtedString.length)];

  // -- Text color for typeString string -- //
  [attributtedString addAttribute:NSForegroundColorAttributeName
                            value:kNormalPostTextColor
                            range:NSMakeRange(0, typeString.length)];
  
  // -- Text color for cause tag -- //
  NSRange tagRangeCause = [postInfoString rangeOfString:cause];
  [attributtedString addAttribute:NSForegroundColorAttributeName value:kTagsTextColor range:tagRangeCause];
  
  
  if (location.length > 0) {
    // -- text color for 'at' string -- //
    NSRange atStringRange = [postInfoString rangeOfString:atString];
    [attributtedString addAttribute:NSForegroundColorAttributeName value:kNormalPostTextColor range:atStringRange];
    
    // -- text color for Location tag -- //
    NSRange locationTagRange = [postInfoString rangeOfString:location];
    [attributtedString addAttribute:NSForegroundColorAttributeName value:kTagsTextColor range:locationTagRange];
  }
  
  /*!
   * This method is supposed to be call after a successful call to startFetchingNextResults.
   */

  
  NSMutableArray *createdAtLabelTagsWithRanges = [[NSMutableArray alloc] init];
  
  NSDictionary *dict_createdAt = [[NSDictionary alloc] initWithObjectsAndKeys:self.feedObject.postToID, kTagobjId, self.feedObject.postToName, kTagobjText, kFeedTagTypeCause, kTagobjType, [NSValue valueWithRange:tagRangeCause], @"range", nil];
  [createdAtLabelTagsWithRanges addObject:dict_createdAt];
  createdLabel.tagsArray  = createdAtLabelTagsWithRanges;
  [createdLabel setAttributedText:attributtedString];
  __weak typeof(self) weakSelf = self;
  createdLabel.nameTagTapped = ^(int index) {
    weakSelf.feedCellTagAction(dict_createdAt);
  };
}

- (void)setBottomBorderHeightFor:(NSString*)pageType
{
  if ([pageType isEqualToString:kHomefeedCellID])
  {
    bottomBorderHeight.constant = 0;
  }
  else if ([pageType isEqualToString:kCommentsfeedCellID])
  {
    topBorderheight.constant = 0;
  }
}

- (void)setFeedTimeLabel
{
  NSString *time_ = [LCUtilityManager performNullCheckAndSetValue:self.feedObject.createdAt];
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:time_.longLongValue/1000];
  NSString *timeAgo = [date timeAgo];
  [timeLabel setText:timeAgo];
}

- (void)setPostDescription
{
  
  NSMutableString * friendsTotag = [[NSMutableString alloc] init];
  for (LCTag * tag in self.feedObject.postTags) {
    [friendsTotag appendString:[NSString stringWithFormat:@" @%@",tag.text]];
  }
  
  //never ever forget to add the font attribute to the tagged label
  NSMutableString * completeFeedMessage = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",self.feedObject.message,friendsTotag]];
  NSMutableAttributedString * postDescriptionString = [[NSMutableAttributedString alloc] initWithString:completeFeedMessage];
  
  if (friendsTotag.length > 0) {
    NSRange locationTagRange = [completeFeedMessage rangeOfString:friendsTotag];
    [postDescriptionString addAttribute:NSForegroundColorAttributeName value:kTagsTextColor range:locationTagRange];
  }
  
  NSMutableArray *postDescriptionTagsWithRanges = [[NSMutableArray alloc] init];
  for (int i = 0; i<self.feedObject.postTags.count; i++)
  {
    LCTag * tag = self.feedObject.postTags[i];
    NSRange tagRangePost = [completeFeedMessage rangeOfString:[tag text]];
    NSDictionary *dic_post = [[NSDictionary alloc] initWithObjectsAndKeys:tag.tagID, @"id", tag.text, @"text", tag.type, @"type", [NSValue valueWithRange:tagRangePost], @"range", nil];
    [postDescriptionTagsWithRanges addObject:dic_post];
    
  }
  [postDescriptionString addAttributes:@{
                                         NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:13],
                                         } range:NSMakeRange(0, postDescriptionString.length)];
  postDescription.tagsArray  = postDescriptionTagsWithRanges;
  [postDescription setAttributedText:postDescriptionString];
  __weak typeof(self) weakSelf = self;
  postDescription.nameTagTapped = ^(int index) {
    if (weakSelf.feedCellTagAction) {
      weakSelf.feedCellTagAction(postDescriptionTagsWithRanges[index]);
    }
  };
}

- (void)setData:(LCFeed *)feed forPage :(NSString *)pageType
{
  
  [self layoutIfNeeded];
  retryButton.hidden = true;
  self.feedObject = feed;
  [self setProfilePic];
  [self setFeedUserName];
  [self setFeedInfoDetails];
  [self setBottomBorderHeightFor:pageType];
  [self setFeedTimeLabel];
  
  // -- Thanks & Comments count label -- //
  NSString *thanks_ = [LCUtilityManager performNullCheckAndSetValue:feed.likeCount];
  NSString *comments_ = [LCUtilityManager performNullCheckAndSetValue:feed.commentCount];
  UIImage * iconImage = [[UIImage imageNamed:@"ThanksIcon_enabled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [thanksBtnImage setImage:iconImage];
  [thanksBtnImage setLikeUnlikeStatusImage:self.feedObject.didLike];
  [thanksLabel setText:thanks_];
  [commentsLabel setText:comments_];
  [self setPostDescription];
}

- (IBAction)likeAction:(id)sender
{
  __weak typeof(self.feedObject) feedObject_ = self.feedObject;
  UIButton *btonsender = (UIButton*)sender;
  __weak typeof(btonsender) btn = btonsender;
  btn.userInteractionEnabled = NO;
  __weak typeof(thanksBtnImage) tankImageView_ref = thanksBtnImage;
  tankImageView_ref.alpha = 0.6;
  __weak typeof(thanksLabel) thanksLabel_ref = thanksLabel;
  
  if ([feedObject_.didLike boolValue]) {
    [tankImageView_ref setLikeUnlikeStatusImage:kUnLikedStatus];
    NSString * likeCount = [LCUtilityManager performNullCheckAndSetValue:feedObject_.likeCount];
    NSInteger thanksCount = [likeCount integerValue] > 0 ? [likeCount integerValue] -1 : 0;
    [thanksLabel_ref setText:[NSString stringWithFormat:@"%d",(int)thanksCount]];
    [LCAPIManager unlikePost:feedObject_ withSuccess:^(id response) {
      btn.userInteractionEnabled = YES;
      tankImageView_ref.alpha = 1.0;
    } andFailure:^(NSString *error) {
      [tankImageView_ref setLikeUnlikeStatusImage:feedObject_.didLike];
      [thanksLabel_ref setText:[LCUtilityManager performNullCheckAndSetValue:feedObject_.likeCount]];
      btn.userInteractionEnabled = YES;
      tankImageView_ref.alpha = 1.0;
    }];
  }
  else
  {
    NSString * likeCount = [LCUtilityManager performNullCheckAndSetValue:feedObject_.likeCount];
    [thanksLabel_ref setText:[NSString stringWithFormat:@"%d",[likeCount intValue] + 1]];
    [tankImageView_ref setLikeUnlikeStatusImage:kLikedStatus];
    [LCAPIManager likePost:feedObject_ withSuccess:^(id response) {
      btn.userInteractionEnabled = YES;
      tankImageView_ref.alpha = 1.0;
    } andFailure:^(NSString *error) {
      [tankImageView_ref setLikeUnlikeStatusImage:feedObject_.didLike];
      [thanksLabel_ref setText:[LCUtilityManager performNullCheckAndSetValue:feedObject_.likeCount]];
      btn.userInteractionEnabled = YES;
      tankImageView_ref.alpha = 1.0;
    }];
  }
}

- (IBAction)commentAction
{
  if (self.feedCellAction)
  {
    self.feedCellAction(kFeedCellActionComment,feedObject);
  }
}

- (IBAction)imageFullscreenAction
{
  if (self.feedCellAction)
  {
    self.feedCellAction(kkFeedCellActionViewImage,feedObject);
  }
}

- (IBAction)moreButtonAction
{
  if (self.feedCellAction)
  {
    self.feedCellAction(kkFeedCellActionLoadMore,feedObject);
  }
}

- (IBAction)retryLoadingFeedImage: (id)sender
{
 
  imageLoadingActivity.hidden = false;
  [imageLoadingActivity startAnimating];
  [postPhoto setBackgroundColor:kImageLoadingBackColor];
  [postPhoto.layer setCornerRadius:5];
  [postPhoto setClipsToBounds:YES];
  retryButton.hidden = true;
  NSString *imageURL = self.feedObject.thumbImage;//url for testing nill image - @"http://10.3.0.55:8000/picture/people-and-the-gloe1.gif.png";
  if (sender)//controlled caching for retry failed or null images
  {
    [postPhoto sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      [imageLoadingActivity stopAnimating];
      imageLoadingActivity.hidden = true;
      if (image) {
        [postPhoto setBackgroundColor:[UIColor clearColor]];
      }
      else
      {
        retryButton.layer.cornerRadius = 5;
        retryButton.layer.borderColor = [UIColor whiteColor].CGColor;
        retryButton.layer.borderWidth = 3;
        retryButton.hidden = false;
      }
    }];
  }
  else//default behaviour
  {
    [postPhoto sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      [imageLoadingActivity stopAnimating];
      imageLoadingActivity.hidden = true;
      if (image) {
        [postPhoto setBackgroundColor:[UIColor clearColor]];
      }
      else
      {
        retryButton.layer.cornerRadius = 5;
        retryButton.layer.borderColor = [UIColor whiteColor].CGColor;
        retryButton.layer.borderWidth = 3;
        retryButton.hidden = false;
      }
    }];
  }
  
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
