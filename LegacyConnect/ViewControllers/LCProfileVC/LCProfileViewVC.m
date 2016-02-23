//
//  LCProfileViewVC.m
//  LegacyConnect
//
//  Created by User on 7/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCProfileViewVC.h"
#import "LCProfileEditVC.h"
#import "LCImapactsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCFriendsListViewController.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>
#import "LCFeedsCommentsController.h"
#import "LCCreatePostViewController.h"
#import "LCViewActions.h"

@implementation LCProfileViewVC

#pragma mark - controller life cycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialSetUp];
  [self addTabMenu];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [LCUtilityManager setLCStatusBarStyle];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:NO MenuHiddenStatus:NO];
  if (self.navigationController.viewControllers.count <= 1)
  {
    [backButton setHidden:YES];
  }
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
  
  if ([segue.identifier isEqualToString:@"LCMileStonesSegue"]) {
    
    mileStonesVC = segue.destinationViewController;
    mileStonesVC.userID = self.userDetail.userID;
    mileStonesVC.delegate = self;
  }
  else if ([segue.identifier isEqualToString:@"LCInterestsSegue"]) {
    
    interestsVC = segue.destinationViewController;
    interestsVC.userID = self.userDetail.userID;
    interestsVC.delegate = self;
  }
  else if ([segue.identifier isEqualToString:@"LCActionsSegue"]) {
    
    actionsVC = segue.destinationViewController;
    actionsVC.userID = self.userDetail.userID;
    actionsVC.delegate = self;
  }
}

#pragma mark - private method implementation

- (void)initialSetUp
{
  profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
  profilePicBorderView.layer.cornerRadius = profilePicBorderView.frame.size.width/2;
  profilePic.image = [UIImage imageNamed:@"userProfilePic"];
  
  userNameLabel.text = kEmptyStringValue;
  memeberSincelabel.text = kEmptyStringValue;
  locationLabel.text = kEmptyStringValue;
  
  
  NSString *nativeUserId = [LCDataManager sharedDataManager].userID;
  if ([nativeUserId isEqualToString:self.userDetail.userID] || !self.userDetail.userID)
  {
    [self setCurrentProfileStatus:kMyProfile];
  }
  else
  {
    [self setCurrentProfileStatus:kNonFriend];
  }
  
  [self loaduserDetails];
}

- (void)loaduserDetails
{
  friendsButton.enabled = NO;
  [LCUserProfileAPIManager getUserDetailsOfUser:self.userDetail.userID WithSuccess:^(id response) {
    
    if(currentProfileStatus == kMyProfile) {
      [LCUtilityManager saveUserDetailsToDataManagerFromResponse:response];
    }
    
    self.userDetail = response;
    [self updateUserDetailUI];
    friendsButton.enabled = YES;

    if (currentProfileStatus == kMyProfile) {
      [self showTabBarAndLoadMilestones];
    }
    else {
      [self checkPrivacySettings];
    }
  } andFailure:^(NSString *error) {
    LCDLog(@"%@",error);
  }];
}


- (void)addTabMenu
{
  tabmenu.menuButtons = [[NSArray alloc] initWithObjects:mileStonesButton, interestsButton, actionsButton, nil];
  tabmenu.views = [[NSArray alloc] initWithObjects:milestonesContainer, interestsContainer, actionsContainer, nil];
}

- (void) sendFriendRequest {
  
  [self setCurrentProfileStatus:kRequestWaiting];
  friendsButton.userInteractionEnabled = NO;
  [LCProfileAPIManager sendFriendRequest:self.userDetail.userID withSuccess:^(NSDictionary *response) {
    friendsButton.userInteractionEnabled = YES;
  } andFailure:^(NSString *error) {
    [self setCurrentProfileStatus:kNonFriend];
    friendsButton.userInteractionEnabled = YES;
  }];
}

- (void) cancelFriendRequest {
  
  [self setCurrentProfileStatus:kNonFriend];
  friendsButton.userInteractionEnabled = NO;
  [LCProfileAPIManager cancelFriendRequest:self.userDetail.userID withSuccess:^(NSArray *response) {
    friendsButton.userInteractionEnabled = YES;
  } andFailure:^(NSString *error) {
    [self setCurrentProfileStatus:kRequestWaiting];
    friendsButton.userInteractionEnabled = YES;
  }];
}

- (void) removeFriend {
  
  [self setCurrentProfileStatus:kNonFriend];
  friendsButton.userInteractionEnabled = NO;
  [LCProfileAPIManager removeFriend:self.userDetail.userID withSuccess:^(NSArray *response)
   {
     friendsButton.userInteractionEnabled = YES;
   }
   andFailure:^(NSString *error)
   {
     [self setCurrentProfileStatus:kIsFriend];
     friendsButton.userInteractionEnabled = YES;
   }];
}

#pragma mark - button actions
- (IBAction)friendsButtonClicked
{
  LCFriendsListViewController * friendsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCFriendsListVC"];
  friendsVC.userId = self.self.userDetail.userID;
  [self.navigationController pushViewController:friendsVC animated:YES];
}

- (IBAction)impactsButtonClicked
{
  UIStoryboard*  profileSB = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
  LCImapactsViewController *impactsVC = [profileSB instantiateViewControllerWithIdentifier:@"LCImapactsViewController"];
  impactsVC.self.userDetail = self.userDetail;
  [self.navigationController pushViewController:impactsVC animated:YES];
}

- (IBAction)backAction:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editClicked:(UIButton *)sender
{
  
  if (currentProfileStatus == kMyProfile)
  {
    UIStoryboard*  profileSB = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
    LCProfileEditVC *editProfileVC = [profileSB instantiateViewControllerWithIdentifier:@"LCProfileEditVC"];
    editProfileVC.self.userDetail = self.self.userDetail;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:editProfileVC];
    [navC.interactivePopGestureRecognizer setDelegate:nil];
    [self presentViewController:navC animated:YES completion:nil];
  }
  else if (currentProfileStatus == kIsFriend)
  {
    //remove friend
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    actionSheet.view.tintColor = [UIColor blackColor];
    
    UIAlertAction *removeFriend = [UIAlertAction actionWithTitle:@"Remove Friend" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
      
      [self removeFriend];
    }];
    [actionSheet addAction:removeFriend];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
  }
  else if (currentProfileStatus == kNonFriend)
  {
    //send friend request
    [self sendFriendRequest];
  }
  else if (currentProfileStatus == kRequestWaiting)
  {
    //cancel friend request
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    actionSheet.view.tintColor = [UIColor blackColor];
    
    UIAlertAction *cancelFreindRequest = [UIAlertAction actionWithTitle:@"Cancel Friend Request" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
      
      [self cancelFriendRequest];
    }];
    [actionSheet addAction:cancelFreindRequest];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
  }
}

- (IBAction)mileStonesClicked:(id)sender
{
  if (tabmenu.currentIndex != 0) {
    [mileStonesVC loadMileStones];
  }
}

- (IBAction)interestsClicked:(id)sender
{
  if (tabmenu.currentIndex != 1) {
    [interestsVC loadInterests];
  }
}

- (IBAction)actionsClicked:(id)sender
{
  if (tabmenu.currentIndex != 2) {
    [actionsVC loadActions];
  }
}


#pragma mark - ScrollView Custom Delelgate

- (void)scrollViewScrolled:(UIScrollView *)scrollView {
  
  if (scrollView.contentOffset.y <= 0 && collapseViewHeight.constant >=170) //Added this line to KOAPullToRefresh to work correctly.
  {
    return;
  }
  
  float collapseConstant = 0;;
  if (collapseViewHeight.constant>0)
  {
    collapseConstant = collapseViewHeight.constant - scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
  }
  if (collapseViewHeight.constant<170 && scrollView.contentOffset.y<0)
  {
    collapseConstant = collapseViewHeight.constant - scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
  }
  if (collapseConstant<0)
  {
    collapseConstant = 0;
  }
  if (collapseConstant>170)
  {
    collapseConstant = 170;
  }
  collapseViewHeight.constant = collapseConstant;
}

@end
