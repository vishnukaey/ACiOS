//
//  LCSingleInterestVC.m
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSingleInterestVC.h"
#import "LCSingleCauseVC.h"
#import "UIImage+LCImageBlur.h"


@implementation LCSingleInterestVC

#pragma mark - Controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self initialSetup];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:NO MenuHiddenStatus:NO];
}

#pragma mark - Private Methods
- (void) initialSetup
{
  tabmenu.menuButtons = [[NSArray alloc] initWithObjects:postsButton, causesButton, actionsButton, nil];
  tabmenu.views = [[NSArray alloc] initWithObjects:postsContainer, causesContainer, actionsContainer, nil];
  
  interestName.text = kEmptyStringValue;
  interestDescription.text = kEmptyStringValue;
  
  //[self updateInterestDetails];
  [self getInterestDetails];
}

- (void) getInterestDetails
{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCThemeAPIManager getInterestDetailsOfInterest:self.interest.interestID WithSuccess:^(LCInterest *response) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.interest = response;
    [self updateInterestDetails];
    [interestPostsView loadPostsInCurrentInterest];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }];
}

- (void) updateInterestDetails
{
  interestName.text = _interest.name;
  interestDescription.text = _interest.descriptionText;
  [interestImage sd_setImageWithURL:[NSURL URLWithString:_interest.logoURLSmall] placeholderImage:nil];
  
  SDWebImageManager *manager = [SDWebImageManager sharedManager];
  [manager downloadImageWithURL:[NSURL URLWithString:_interest.logoURLSmall]
                        options:0
                       progress:nil
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        if (image) {
                          
                          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            UIImage *bluredImage = [image bluredImage];
                            dispatch_async(dispatch_get_main_queue(), ^{
                              interestBGImage.image = bluredImage;
                            });
                          });
                        }
                      }];
  
  followersCount.text = _interest.followers;
  actionsCount.text = _interest.events;
  [interestFollowButton setSelected:_interest.isFollowing];
}

#pragma mark - Action Mehtods
- (IBAction)backAction:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)followAction:(id)sender
{
  interestFollowButton.userInteractionEnabled = NO;
  if(!interestFollowButton.selected)
  {
    [interestFollowButton setSelected:YES];
    [LCThemeAPIManager followInterest:_interest withSuccess:^(id response) {
      _interest.isFollowing =YES;
      _interest.followers = [NSString stringWithFormat:@"%d",[_interest.followers intValue]+1];
      interestFollowButton.userInteractionEnabled = YES;
    } andFailure:^(NSString *error) {
      [interestFollowButton setSelected:NO];
      interestFollowButton.userInteractionEnabled = YES;
    }];
  }
  else
  {
    [interestFollowButton setSelected:NO];
    [LCThemeAPIManager unfollowInterest:_interest withSuccess:^(id response) {
      interestFollowButton.userInteractionEnabled = YES;
      _interest.isFollowing = NO;
      _interest.followers = [NSString stringWithFormat:@"%d",[_interest.followers intValue]-1];
    } andFailure:^(NSString *error) {
      interestFollowButton.userInteractionEnabled = YES;
      [interestFollowButton setSelected:YES];
    }];
  }
}

- (IBAction)showFollowers:(id)sender {
  
  
}


- (IBAction)postsButtonClicked:(id)sender
{
  if (tabmenu.currentIndex != 0) {
    [interestPostsView loadPostsInCurrentInterest];
  }
}

- (IBAction)causesButtonClicked:(id)sender
{
  if (tabmenu.currentIndex != 1) {
    [interestCausesView loadCausesInCurrentInterest];
  }
}

- (IBAction)actionsButtonClicked:(id)sender
{
  if (tabmenu.currentIndex != 2) {
    [interestActionsView loadActionsInCurrentInterest];
  }
}



- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
  
  if ([segue.identifier isEqualToString:@"LCInterestPostsSegue"]) {
    
    interestPostsView = segue.destinationViewController;
    interestPostsView.interest = self.interest;
    interestPostsView.delegate = self;
  }
  else if ([segue.identifier isEqualToString:@"LCInterestCausesSegue"]) {
    
    interestCausesView = segue.destinationViewController;
    interestCausesView.interest = self.interest;
    interestCausesView.delegate = self;
  }
  else if ([segue.identifier isEqualToString:@"LCInterestActionsSegue"]) {
    
    interestActionsView = segue.destinationViewController;
    interestActionsView.interest = self.interest;
    interestActionsView.delegate = self;
  }
  else if ([segue.identifier isEqualToString:@"showActionsList"]) {
    
    interestActionsView = segue.destinationViewController;
    interestActionsView.interest = self.interest;
    [interestActionsView loadActionsInCurrentInterest];
  }
}


#pragma mark - ScrollView Custom Delelgate

- (void)scrollViewScrolled:(UIScrollView *)scrollView {
  
  CGFloat viewHeight = 265.0;
  
  if (scrollView.contentOffset.y <= 0 && collapseViewHeight.constant >= viewHeight) //Added this line to KOAPullToRefresh to work correctly.
  {
    return;
  }
  
  float collapseConstant = 0;;
  if (collapseViewHeight.constant > 0)
  {
    collapseConstant = collapseViewHeight.constant - scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
  }
  if (collapseViewHeight.constant < viewHeight && scrollView.contentOffset.y < 0)
  {
    collapseConstant = collapseViewHeight.constant - scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
  }
  if (collapseConstant < 0)
  {
    collapseConstant = 0;
  }
  if (collapseConstant > viewHeight)
  {
    collapseConstant = viewHeight;
  }
  collapseViewHeight.constant = collapseConstant;
}

@end
