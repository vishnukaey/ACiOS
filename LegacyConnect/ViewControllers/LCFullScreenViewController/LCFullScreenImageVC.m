//
//  LCFullScreenImageVC.m
//  LegacyConnect
//
//  Created by User on 7/31/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFullScreenImageVC.h"
#import "LCThanksButtonImage.h"
#import "LCReportHelper.h"

@interface LCFullScreenImageVC ()
{
   BOOL GIButton_preState, menuButton_preState;
}
@property(nonatomic, retain)UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fullScreenImageView;
@property (weak, nonatomic) IBOutlet LCThanksButtonImage *thanksButtonImage;
@property (weak, nonatomic) IBOutlet UILabel *thanksCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentIconImahe;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoadingActivity;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@end

@implementation LCFullScreenImageVC
@synthesize imageView;

- (void)dataPopulation
{
  
  NSString * user = [NSString stringWithFormat:@"%@ %@",[LCUtilityManager performNullCheckAndSetValue:self.feed.firstName],[LCUtilityManager performNullCheckAndSetValue:self.feed.lastName]];
  
  [self.titleLabel setText:[user uppercaseString]];
  
  //-- Like --//
  UIImage *iconImage = [[UIImage imageNamed:@"ThanksIcon_enabled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.thanksButtonImage setImage:iconImage];
  [self.thanksButtonImage setLikeUnlikeStatusImage:self.feed.didLike];
  [self setLikeCount:[LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount]];
  
  //-- Comment --//
  [self.commentCountLabel setText:[NSString stringWithFormat:@"%@ Comments",[LCUtilityManager performNullCheckAndSetValue:self.feed.commentCount]]];
  [self setCommentCount:[LCUtilityManager performNullCheckAndSetValue:self.feed.commentCount]];
}

- (IBAction)tryImageLoading:(id)sender
{
  
  self.imageLoadingActivity.hidden = false;
  [self.imageLoadingActivity startAnimating];
  self.retryButton.hidden = true;
  if (sender)//controlled caching for retry failed or null images
  {
    [self.fullScreenImageView sd_setImageWithURL:[NSURL URLWithString:self.feed.image] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      [self.imageLoadingActivity stopAnimating];
      self.imageLoadingActivity.hidden = true;
      if (!image) {
        self.retryButton.layer.cornerRadius = 5;
        self.retryButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.retryButton.layer.borderWidth = 3;
        self.retryButton.hidden = false;
      }
    }];
  }
  else//default behaviour
  {
    [self.fullScreenImageView sd_setImageWithURL:[NSURL URLWithString:self.feed.image] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      [self.imageLoadingActivity stopAnimating];
      self.imageLoadingActivity.hidden = true;
      if (!image) {
        self.retryButton.layer.cornerRadius = 5;
        self.retryButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.retryButton.layer.borderWidth = 3;
        self.retryButton.hidden = false;
      }
    }];
  }
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self tryImageLoading:nil];
  [self dataPopulation];
  
  if ([_feed.userID isEqualToString:[LCDataManager sharedDataManager].userID])
  {
    self.reportButton.hidden = YES;
  }
  else
  {
    self.reportButton.hidden = NO;
  }
  
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  appdel.isCreatePostOpen = true;//it is to prevent blinking the create post button during the dismissal of report post or block user controller
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  GIButton_preState = [appdel.GIButton isHidden];
  menuButton_preState = [appdel.menuButton isHidden];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  appdel.isCreatePostOpen = false;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:GIButton_preState MenuHiddenStatus:menuButton_preState];
}

#pragma mark - button actions
- (IBAction)doneAction:sender
{
  __weak typeof(self) weakSelf = self;
  if (self.commentAction) {
    self.commentAction(weakSelf, NO);
  }
  else
  {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

- (IBAction)likeButtonClicked:(id)sender
{
  UIButton * btn = (UIButton*)sender;
  [btn setEnabled:NO];
  if ([self.feed.didLike boolValue]) {
    [self.thanksButtonImage setLikeUnlikeStatusImage:kUnLikedStatus];
    NSString *likeCount = [LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount];
    [self setLikeCount:[NSString stringWithFormat:@"%d Thanks",[likeCount intValue]-1]];
    [LCFeedAPIManager unlikePost:self.feed withSuccess:^(id response) {
      self.feed.didLike = kUnLikedStatus;
      self.feed.likeCount = [(NSDictionary*)[response objectForKey:@"data"] objectForKey:@"likeCount"];
      [btn setEnabled:YES];
    } andFailure:^(NSString *error) {
      [self.thanksButtonImage setLikeUnlikeStatusImage:self.feed.didLike];
      [self setLikeCount:[LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount]];
      [btn setEnabled:YES];
    }];
  }
  else
  {
    NSString *likeCount = [LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount];
    [self setLikeCount:[NSString stringWithFormat:@"%d Thanks",[likeCount intValue]+1]];
    [self.thanksButtonImage setLikeUnlikeStatusImage:kLikedStatus];
    [LCFeedAPIManager likePost:self.feed withSuccess:^(id response) {
      self.feed.didLike = kLikedStatus;
      self.feed.likeCount = [(NSDictionary*)[response objectForKey:@"data"] objectForKey:@"likeCount"];
      [btn setEnabled:YES];
    } andFailure:^(NSString *error) {
      [self.thanksButtonImage setLikeUnlikeStatusImage:self.feed.didLike];
      [self setLikeCount:[LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount]];
      [btn setEnabled:YES];
    }];
  }
}

- (IBAction)commentButtonClicked:(id)sender
{
  __weak typeof(self) weakSelf = self;
  if (self.commentAction) {
    self.commentAction(weakSelf, YES);
  }
}
- (IBAction)reportFeed:(id)sender {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GIAndMenuButtonUpdateOnDismissal) name:@"block_details_screen_dismissed" object:nil];
  [LCReportHelper showPostReportActionSheetFromView:self withPost:self.feed];
}

- (void)GIAndMenuButtonUpdateOnDismissal
{
  if (self.isViewLoaded && self.view.window) {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"block_details_screen_dismissed" object:nil];
    [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
  }
}
- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"block_details_screen_dismissed" object:nil];
}


-(void)setLikeCount:(NSString*)count
{
  
  NSString *thanks_ = @"Thank";
  if ([count integerValue] >1) {
    thanks_ = [[LCUtilityManager performNullCheckAndSetValue:count] stringByAppendingString:@" Thanks"];
  }
  else if ([count integerValue] == 1) {
    thanks_ = [[LCUtilityManager performNullCheckAndSetValue:count] stringByAppendingString:@" Thank"];
  }
  NSMutableAttributedString *thanksAtrributted_string = [[NSMutableAttributedString alloc] initWithString:thanks_];
  [thanksAtrributted_string addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor lightGrayColor]
                                   range:[thanks_ rangeOfString:@"Thank"]];
  [thanksAtrributted_string addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor lightGrayColor]
                                   range:[thanks_ rangeOfString:@"Thanks"]];
  [thanksAtrributted_string addAttributes:@{
                                            NSFontAttributeName : [UIFont fontWithName:@"Gotham-Bold" size:12.0f],
                                            } range:NSMakeRange(0, thanks_.length)];
  [self.thanksCountLabel setAttributedText:thanksAtrributted_string];
}



-(void)setCommentCount:(NSString*)count
{
  NSString *comments_ = @"Comment";
  if ([count integerValue] >1) {
    comments_ = [[LCUtilityManager performNullCheckAndSetValue:count] stringByAppendingString:@" Comments"];
  }
  else if ([count integerValue] == 1) {
    comments_ = [[LCUtilityManager performNullCheckAndSetValue:count] stringByAppendingString:@" Comment"];
  }
  NSMutableAttributedString * commentsAtrributted_string = [[NSMutableAttributedString alloc] initWithString:comments_];
  [commentsAtrributted_string addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor lightGrayColor]
                                     range:[comments_ rangeOfString:@"Comment"]];
  [commentsAtrributted_string addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor lightGrayColor]
                                     range:[comments_ rangeOfString:@"Comments"]];
  [commentsAtrributted_string addAttributes:@{
                                              NSFontAttributeName : [UIFont fontWithName:@"Gotham-Bold" size:12.0f],
                                              } range:NSMakeRange(0, comments_.length)];
  [self.commentCountLabel setAttributedText:commentsAtrributted_string];
}


@end
