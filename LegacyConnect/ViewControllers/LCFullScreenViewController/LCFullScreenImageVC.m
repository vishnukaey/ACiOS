//
//  LCFullScreenImageVC.m
//  LegacyConnect
//
//  Created by User on 7/31/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFullScreenImageVC.h"
#import "LCThanksButtonImage.h"

@interface LCFullScreenImageVC ()
@property(nonatomic, retain)UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fullScreenImageView;
@property (weak, nonatomic) IBOutlet LCThanksButtonImage *thanksButtonImage;
@property (weak, nonatomic) IBOutlet UILabel *thanksCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentIconImahe;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@end

@implementation LCFullScreenImageVC
@synthesize imageView;

- (void)dataPopulation
{
  [self.fullScreenImageView sd_setImageWithURL:[NSURL URLWithString:self.feed.image] placeholderImage:nil];
  
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

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self dataPopulation];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

- (void)viewWillDisappear:(BOOL)animated {
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [appdel.menuButton setHidden:NO];
  [super viewWillDisappear:animated];
}

- (IBAction)likeButtonClicked:(id)sender
{
  if ([self.feed.didLike boolValue]) {
    [self.thanksButtonImage setLikeUnlikeStatusImage:kUnLikedStatus];
    NSString * likeCount = [LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount];
    [self.thanksCountLabel setText:[NSString stringWithFormat:@"%i",[likeCount integerValue] -1]];
    [LCAPIManager unlikePost:self.feed.entityID withSuccess:^(id response) {
      self.feed.didLike = kUnLikedStatus;
      self.feed.likeCount = [(NSDictionary*)[response objectForKey:@"data"] objectForKey:@"likeCount"];
    } andFailure:^(NSString *error) {
      [self.thanksButtonImage setLikeUnlikeStatusImage:self.feed.didLike];
      [self.thanksCountLabel setText:[LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount]];
    }];
  }
  else
  {
    NSString * likeCount = [LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount];
    [self.thanksCountLabel setText:[NSString stringWithFormat:@"%i",[likeCount integerValue] + 1]];
    [self.thanksButtonImage setLikeUnlikeStatusImage:kLikedStatus];
    [LCAPIManager likePost:self.feed.entityID withSuccess:^(id response) {
      self.feed.didLike = kLikedStatus;
      self.feed.likeCount = [(NSDictionary*)[response objectForKey:@"data"] objectForKey:@"likeCount"];
    } andFailure:^(NSString *error) {
      [self.thanksButtonImage setLikeUnlikeStatusImage:self.feed.didLike];
      [self.thanksCountLabel setText:[LCUtilityManager performNullCheckAndSetValue:self.feed.likeCount]];
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

@end
