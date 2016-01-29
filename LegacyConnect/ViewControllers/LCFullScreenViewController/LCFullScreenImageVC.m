//
//  LCFullScreenImageVC.m
//  LegacyConnect
//
//  Created by User on 7/31/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFullScreenImageVC.h"
#import "LCThanksButtonImage.h"
#import "LCReportPostViewController.h"

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

@end

@implementation LCFullScreenImageVC
@synthesize imageView;

- (void)dataPopulation
{
  
  NSString * user = [NSString stringWithFormat:@"%@ %@",[LCUtilityManager performNullCheckAndSetValue:self.feed.firstName],[LCUtilityManager performNullCheckAndSetValue:self.feed.lastName]];
  
  [self.titleLabel setText:[user uppercaseString]];
  
  //-- Like --//
  UIImage * iconImage = [[UIImage imageNamed:@"ThanksIcon_enabled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.thanksButtonImage setImage:iconImage];
  [self.thanksButtonImage setLikeUnlikeStatusImage:self.feed.didLike];
  [self.thanksCountLabel setText:[LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount]];
  
  //-- Comment --//
  [self.commentCountLabel setText:[LCUtilityManager performNullCheckAndSetValue:self.feed.commentCount]];
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
  
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  GIButton_preState = [appdel.GIButton isHidden];
  menuButton_preState = [appdel.menuButton isHidden];
  [appdel.GIButton setHidden: true];
  [appdel.menuButton setHidden: true];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden: GIButton_preState];
  [appdel.menuButton setHidden: menuButton_preState];
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
//
//- (void)viewWillDisappear:(BOOL)animated {
//  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
//  [appdel.GIButton setHidden:NO];
//  [appdel.menuButton setHidden:NO];
//  [super viewWillDisappear:animated];
//}

- (IBAction)likeButtonClicked:(id)sender
{
  UIButton * btn = (UIButton*)sender;
  [btn setEnabled:NO];
  if ([self.feed.didLike boolValue]) {
    [self.thanksButtonImage setLikeUnlikeStatusImage:kUnLikedStatus];
    NSString * likeCount = [LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount];
    [self.thanksCountLabel setText:[NSString stringWithFormat:@"%d",[likeCount intValue]-1]];
    [LCFeedAPIManager unlikePost:self.feed withSuccess:^(id response) {
      self.feed.didLike = kUnLikedStatus;
      self.feed.likeCount = [(NSDictionary*)[response objectForKey:@"data"] objectForKey:@"likeCount"];
      [btn setEnabled:YES];
    } andFailure:^(NSString *error) {
      [self.thanksButtonImage setLikeUnlikeStatusImage:self.feed.didLike];
      [self.thanksCountLabel setText:[LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount]];
      [btn setEnabled:YES];
    }];
  }
  else
  {
    NSString * likeCount = [LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount];
    [self.thanksCountLabel setText:[NSString stringWithFormat:@"%d",[likeCount intValue] + 1]];
    [self.thanksButtonImage setLikeUnlikeStatusImage:kLikedStatus];
    [LCFeedAPIManager likePost:self.feed withSuccess:^(id response) {
      self.feed.didLike = kLikedStatus;
      self.feed.likeCount = [(NSDictionary*)[response objectForKey:@"data"] objectForKey:@"likeCount"];
      [btn setEnabled:YES];
    } andFailure:^(NSString *error) {
      [self.thanksButtonImage setLikeUnlikeStatusImage:self.feed.didLike];
      [self.thanksCountLabel setText:[LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount]];
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
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *reportPost = [UIAlertAction actionWithTitle:NSLocalizedString(@"report_post", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    UIStoryboard*  mainSB = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier
                                                      bundle:nil];
    LCReportPostViewController *report = [mainSB instantiateViewControllerWithIdentifier:@"LCReportPostViewController"];
    report.postToReport = self.feed;
    [self presentViewController:report animated:YES completion:nil];
  }];
  [actionSheet addAction:reportPost];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

@end
