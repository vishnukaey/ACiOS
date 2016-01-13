//
//  LCSingleInterestVC.m
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSingleInterestVC.h"
#import "LCSingleCauseVC.h"


@implementation LCSingleInterestVC

#pragma mark - controller life cycle
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


- (void) initialSetup
{
  [self updateInterestDetails];
  [self addTabMenu];
  
  [interestPostsView loadPostsInCurrentInterest];
}

- (void) updateInterestDetails
{
  interestName.text = _interest.name;
  interestDescription.text = _interest.descriptionText;
  [interestImage sd_setImageWithURL:[NSURL URLWithString:_interest.logoURLSmall] placeholderImage:nil];
  [interestBGImage sd_setImageWithURL:[NSURL URLWithString:_interest.logoURLLarge] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
//    UIColor *topColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
//    UIColor *bottomColor = [UIColor colorWithRed:80.0/255.0 green:80.0/255.0 blue:80.0/255.0 alpha:0.6];
//    
//    CAGradientLayer *gradientMask = [CAGradientLayer layer];
//    gradientMask.frame = interestBGImage.bounds;
//    gradientMask.colors = @[(id)topColor.CGColor,
//                            (id)bottomColor.CGColor];
//    interestBGImage.layer.mask = gradientMask;
  }];
  followersCount.text = _interest.followers;
  [interestFollowButton setSelected:_interest.isFollowing];
}

- (void)addTabMenu
{
  tabmenu = [[LCTabMenuView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [tabMenuContainer addSubview:tabmenu];
  //[tabmenu setBackgroundColor:[UIColor whiteColor]];
  tabmenu.translatesAutoresizingMaskIntoConstraints = NO;
  tabMenuContainer.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
  
  NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:top];
  
  NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:bottom];
  
  NSLayoutConstraint *left =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:left];
  
  NSLayoutConstraint *right =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:right];
  
  //  tabmenu.layer.borderWidth = 3;
  tabmenu.menuButtons = [[NSArray alloc] initWithObjects:postsButton, causesButton, actionsButton, nil];
  tabmenu.views = [[NSArray alloc] initWithObjects:postsContainer, causesContainer, actionsContainer, nil];
}


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
