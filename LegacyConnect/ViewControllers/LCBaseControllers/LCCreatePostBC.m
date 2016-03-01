//
//  LCCreatePostBC.m
//  LegacyConnect
//
//  Created by Jijo on 2/2/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCCreatePostBC.h"

#define ICONBACK_COLOR [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0]
#define POSTTEXT_FONT [UIFont fontWithName:@"Gotham-Book" size:13]

@interface LCCreatePostBC ()
{
    BOOL GIButton_preState, menuButton_preState;
  UILabel *tagsLabel;
}
@end




@implementation LCCreatePostBC

- (void)viewDidLoad {
    [super viewDidLoad];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  GIButton_preState = [appdel.GIButton isHidden];
  menuButton_preState = [appdel.menuButton isHidden];
  appdel.isCreatePostOpen = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:true MenuHiddenStatus:true];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self initialiseScrollSubviewsForPosting];
  [self setCurrentContexts];
  [self.postTextView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  appdel.isCreatePostOpen = false;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:GIButton_preState MenuHiddenStatus:menuButton_preState];
  [appdel.menuButton setHidden: menuButton_preState];
}


- (void)setCurrentContexts//image, interests, causes etc
{
  //if coming from photopost flow
  [self.postImageView setImage:_photoPostPhoto];
  [self arrangePostImageView];
  _photoPostPhoto = nil;
  [self setCurrentCauseAndInterestObj];
  [self didfinishPickingInterest:_selectedInterest andCause:_selectedCause];
  
  if (_postFeedObject.image.length)
  {
    [self.postImageView setFrame:CGRectMake(self.postImageView.frame.origin.x, self.postImageView.frame.origin.y, self.postImageView.frame.size.width, 100)];
    [self.postImageView setBackgroundColor:ICONBACK_COLOR];
    [self.postImageView sd_setImageWithURL:[NSURL URLWithString:_postFeedObject.image] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
       [self.postImageView setBackgroundColor:[UIColor clearColor]];
       [self arrangePostImageView];
     }];
  }
  
  if (_postFeedObject.message.length)
  {
    self.placeHolderLabel.hidden = true;
    self.postTextView.text = _postFeedObject.message;
    [self.postTextView layoutIfNeeded];
    CGRect frame = self.postTextView.frame;
    frame.size.height = self.postTextView.contentSize.height;
    self.postTextView.frame = frame;
  }
  
  [self prepareTaggedFriendsArray];
  
  if (_postFeedObject.location.length)
  {
    self.taggedLocation = _postFeedObject.location;
  }
  
  if ([_postFeedObject.isMilestone integerValue])
  {
    self.milestoneIcon.tag = 1;
    [self.milestoneIcon setImage:[UIImage imageNamed:kmilestoneIconImg]];
  }
  
  [self arrangeTaggedLabel];
  [self arrangePostImageView];
}

- (void)initialiseScrollSubviewsForPosting
{
  float topmargin = 8;
  self.interstIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 50, 50)];
  [_postScrollView addSubview:self.interstIconImageView];
  self.interstIconImageView.backgroundColor = ICONBACK_COLOR;
  self.interstIconImageView.layer.cornerRadius = 4;
  self.interstIconImageView.contentMode = UIViewContentModeScaleAspectFit;
  
  self.postTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.interstIconImageView.frame.origin.x + self.interstIconImageView.frame.size.width + 8, topmargin, _postScrollView.frame.size.width - (self.interstIconImageView.frame.origin.x + self.interstIconImageView.frame.size.width + 8), 35)];
  self.postTextView.text = @"";
  [self.postTextView setFrame:CGRectMake(self.postTextView.frame.origin.x, self.postTextView.frame.origin.y, self.postTextView.frame.size.width, self.postTextView.contentSize.height)];
  [self.postTextView setFont:POSTTEXT_FONT];
  self.postTextView.delegate = self;
  [_postScrollView addSubview:self.postTextView];
  
  self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.postTextView.frame.origin.x+5, self.postTextView.frame.origin.y, self.postTextView.frame.size.width, self.postTextView.frame.size.height)];
  [self.placeHolderLabel setFont:POSTTEXT_FONT];
  [self.placeHolderLabel setText:NSLocalizedString(@"share_news_placeholder_text", nil)];
  [self.placeHolderLabel setTextColor:[UIColor lightGrayColor]];
  [_postScrollView addSubview:self.placeHolderLabel];
  
  tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.postTextView.frame.origin.x, self.postTextView.frame.origin.y + self.postTextView.frame.size.height, self.postTextView.frame.size.width, 0)];
  tagsLabel.numberOfLines = 0;
  [_postScrollView addSubview:tagsLabel];
  
  self.postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.interstIconImageView.frame.origin.y + self.interstIconImageView.frame.size.height + 8, _postScrollView.frame.size.width, 0)];
  [_postScrollView addSubview:self.postImageView];
}

- (void)arrangePostImageView
{
  if (self.postImageView.image) {
    float ratio = self.postImageView.image.size.width / self.postImageView.frame.size.width;
    float height = self.postImageView.image.size.height / ratio;
    CGSize size = CGSizeMake(self.postImageView.frame.size.width, height);
    [self.postImageView setFrame:CGRectMake(self.postImageView.frame.origin.x, self.postImageView.frame.origin.y, size.width, size.height)];
    [self arrangeScrollSubviewsForPosting];
  }
  else
  {
    [self.postImageView setFrame:CGRectMake(self.postImageView.frame.origin.x, self.postImageView.frame.origin.y, 0, 0)];
    [self arrangeScrollSubviewsForPosting];
  }
}

- (void)setCurrentCauseAndInterestObj
{
  if (_postFeedObject.postToID)
  {
    if ([_postFeedObject.postToType isEqualToString:kFeedTagTypeCause])
    {
      _selectedCause = [[LCCause alloc] init];
      _selectedCause.causeID = _postFeedObject.postToID;
      _selectedCause.name = _postFeedObject.postToName;
      _selectedCause.logoURLSmall = _postFeedObject.postToImageURL;
    }
    else if ([_postFeedObject.postToType isEqualToString:kFeedTagTypeInterest])
    {
      _selectedInterest = [[LCInterest alloc] init];
      _selectedInterest.interestID = _postFeedObject.postToID;
      _selectedInterest.name = _postFeedObject.postToName;
      _selectedInterest.logoURLSmall = _postFeedObject.postToImageURL;
    }
  }
}

- (void)prepareTaggedFriendsArray
{
  if (self.postFeedObject.postTags.count)
  {
    NSMutableArray *freinds_tageed = [[NSMutableArray alloc] init];
    for (LCTag *tag in self.postFeedObject.postTags)//now only handling friends tagged. will need separate handling for other types
    {
      if ([tag.type isEqualToString:kFeedTagTypeUser]) {
        LCFriend *friend = [[LCFriend alloc] init];
        friend.friendId = tag.tagID;
        friend.firstName = tag.text;
        [freinds_tageed addObject:friend];
      }
    }
    self.taggedFriendsArray = [freinds_tageed copy];
    
  }
}

#pragma mark - view arrangement
- (void)arrangeTaggedLabel
{
  NSString *tagsString = @"";
  for (LCFriend *friend in self.taggedFriendsArray)
  {
    NSString *friend_name = [NSString stringWithFormat:@"%@ %@", [LCUtilityManager performNullCheckAndSetValue:friend.firstName],
                             [LCUtilityManager performNullCheckAndSetValue:friend.lastName]];
    tagsString = [NSString stringWithFormat:@"%@ @%@",tagsString, friend_name];
  }
  
  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:@""];
  NSAttributedString *attributtedTagString = [[NSAttributedString alloc] initWithString : tagsString
                                                                             attributes : @{
                                                                                            NSFontAttributeName : [UIFont fontWithName:@"Gotham-Medium" size:13],
                                                                                            NSForegroundColorAttributeName : [LCUtilityManager getThemeRedColor],
                                                                                            }];
  [attributtedString appendAttributedString:attributtedTagString];
  if (self.taggedLocation.length>0)
  {
    NSAttributedString *atString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %C at ",0x2014] attributes:@{
                                                                                                                                         NSFontAttributeName : POSTTEXT_FONT,
                                                                                                                                         NSForegroundColorAttributeName : [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1],}];
    NSAttributedString *attributtedLocStrng = [[NSAttributedString alloc] initWithString : [NSString stringWithFormat:@"%@", self.taggedLocation]
                                                                              attributes : @{
                                                                                             NSFontAttributeName : [UIFont fontWithName:@"Gotham-Medium" size:13],
                                                                                             NSForegroundColorAttributeName : [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1],
                                                                                             }];
    [attributtedString appendAttributedString:atString];
    [attributtedString appendAttributedString:attributtedLocStrng];
  }
  [tagsLabel setAttributedText:attributtedString];
  
  CGRect rect = [attributtedString boundingRectWithSize:CGSizeMake(tagsLabel.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
  [tagsLabel setFrame:CGRectMake(tagsLabel.frame.origin.x, tagsLabel.frame.origin.y, tagsLabel.frame.size.width, rect.size.height)];
  
  [self arrangeScrollSubviewsForPosting];
}



- (void)arrangeScrollSubviewsForPosting
{
  [tagsLabel setFrame:CGRectMake(self.postTextView.frame.origin.x, self.postTextView.frame.origin.y + self.postTextView.frame.size.height, self.postTextView.frame.size.width, tagsLabel.frame.size.height)];
  
  float postImageYorigin = tagsLabel.frame.origin.y + tagsLabel.frame.size.height + 8;
  if (postImageYorigin < self.interstIconImageView.frame.origin.y + self.interstIconImageView.frame.size.height+8) {
    postImageYorigin = self.interstIconImageView.frame.origin.y + self.interstIconImageView.frame.size.height+8;
  }
  [self.postImageView setFrame:CGRectMake(0, postImageYorigin, _postScrollView.frame.size.width, self.postImageView.frame.size.height)];
  
  [_postScrollView setContentSize:CGSizeMake(_postScrollView.contentSize.width, self.postImageView.frame.origin.y + self.postImageView.frame.size.height)];
  
  UIImage *tagfirends_im = [UIImage imageNamed:ktagFriendIconImg];
  self.tagFriendsIcon.image = [tagfirends_im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.tagFriendsIcon setTintColor:[UIColor grayColor]];
  
  UIImage *cam_im = [UIImage imageNamed:kcameraIconImg];
  self.cameraIcon.image = [cam_im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.cameraIcon setTintColor:[UIColor grayColor]];
  
  UIImage *tagloc_im = [UIImage imageNamed:ktagLocationIconImg];
  self.tagLocationIcon.image = [tagloc_im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.tagLocationIcon setTintColor:[UIColor grayColor]];
  
  UIImage *miles_im = [UIImage imageNamed:kmilestoneIconImg];
  self.milestoneIcon.image = [miles_im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.milestoneIcon setTintColor:[UIColor grayColor]];
  
  if (self.taggedFriendsArray.count > 0) {
    [self.tagFriendsIcon setTintColor:[UIColor blackColor]];
  }
  
  if (self.taggedLocation.length>0)
  {
    [self.tagLocationIcon setTintColor:[UIColor blackColor]];
  }
  
  if (self.postImageView.image)
  {
    [self.cameraIcon setTintColor:[UIColor blackColor]];
  }
  
  if (self.milestoneIcon.tag) {
    [self.milestoneIcon setImage:[UIImage imageNamed:kmilestoneIconImg]];
  }
}

- (void)adjustScrollViewOffsetWhileTextEditing :(UITextView *)textView
{
  if (textView.selectedTextRange) {
    CGPoint cursorPosition = [textView caretRectForPosition:textView.selectedTextRange.start].origin;
    float btmMarginAdjust = textView.font.pointSize*2;
    if (cursorPosition.y + self.postTextView.frame.origin.y >= _postScrollView.frame.size.height - btmMarginAdjust + _postScrollView.contentOffset.y) {
      CGPoint pointToScroll = CGPointMake(_postScrollView.contentOffset.x, self.postTextView.frame.origin.y + cursorPosition.y - _postScrollView.frame.size.height + btmMarginAdjust);
      [_postScrollView setContentOffset:pointToScroll];
    }
  }
}

- (void)didfinishPickingInterest:(LCInterest *)interest andCause:(LCCause *)cause
{
  [self.interstIconImageView setBackgroundColor:ICONBACK_COLOR];
  if (interest) {
    self.postingToLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:13];
    self.postingToLabel.text = interest.name;
    [self.interstIconImageView sd_setImageWithURL:[NSURL URLWithString:interest.logoURLSmall] placeholderImage:nil];
  }
  else if (cause)
  {
    self.postingToLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13];
    self.postingToLabel.text = cause.name;
    [self.interstIconImageView sd_setImageWithURL:[NSURL URLWithString:cause.logoURLSmall] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
       [self.interstIconImageView setBackgroundColor:[UIColor whiteColor]];
     }];
  }
  self.selectedCause = cause;
  self.selectedInterest = interest;
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""])
  {
    self.placeHolderLabel.hidden = false;
  }
  else
  {
    self.placeHolderLabel.hidden = true;
  }
  [self adjustScrollViewOffsetWhileTextEditing:textView];
  
  CGRect frame = textView.frame;
  frame.size.height = textView.contentSize.height;
  textView.frame = frame;
  [self arrangeScrollSubviewsForPosting];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
