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

static NSString * const kImageNameProfileSettings = @"profileSettings";
static NSString * const kImageNameProfileAdd = @"profileAdd";
static NSString * const kImageNameProfileFriend = @"profileFriend";
static NSString * const kImageNameProfileWaiting = @"profileWaiting";

@implementation LCProfileViewVC
@synthesize userDetail;


#pragma mark - controller life cycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
  [mileStonesVC startFetchingResults];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:NO MenuHiddenStatus:NO];
  if (self.navigationController.viewControllers.count <= 1) {
    [backButton setHidden:YES];
  }
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
}

- (void)dealloc {
  
  //Notifications
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kUserProfileUpdateNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kUserProfileFrinendsUpdateNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kUserProfileImpactsUpdateNotification
                                                object:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
  
  if ([segue.identifier isEqualToString:@"LCMileStonesSegue"]) {
    
    mileStonesVC = segue.destinationViewController;
    mileStonesVC.userID = userDetail.userID;
    mileStonesVC.delegate = self;
  }
  else if ([segue.identifier isEqualToString:@"LCInterestsSegue"]) {
    
    interestsVC = segue.destinationViewController;
    interestsVC.userID = userDetail.userID;
    interestsVC.delegate = self;
  }
  else if ([segue.identifier isEqualToString:@"LCActionsSegue"]) {
    
    actionsVC = segue.destinationViewController;
    actionsVC.userID = userDetail.userID;
    actionsVC.delegate = self;
  }
}

#pragma mark - private method implementation

- (void)initialUISetUp
{
  profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
  profilePicBorderView.layer.cornerRadius = profilePicBorderView.frame.size.width/2;
  
  [self loadUserInfo];
  [self addTabMenu];
}

- (void) loadUserInfo {
  
  userNameLabel.text = kEmptyStringValue;
  memeberSincelabel.text = kEmptyStringValue;
  locationLabel.text = kEmptyStringValue;

  NSString *nativeUserId = [LCDataManager sharedDataManager].userID;
  if ([nativeUserId isEqualToString:userDetail.userID] || !userDetail.userID)
  {
    currentProfileState = PROFILE_SELF;
    [editButton setImage:[UIImage imageNamed:kImageNameProfileSettings] forState:UIControlStateNormal];
    
    //Add Notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserData:)
                                                 name:kUserProfileUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateFriendsCount:)
                                                 name:kUserProfileFrinendsUpdateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateImpactsCount:)
                                                 name:kUserProfileImpactsUpdateNotification
                                               object:nil];
  }
  else
  {
    currentProfileState = PROFILE_OTHER_NON_FRIEND;
    [editButton setImage:[UIImage imageNamed:kImageNameProfileAdd] forState:UIControlStateNormal];
  }
  profilePic.image = [UIImage imageNamed:@"userProfilePic"];
  
  [self loadUserDetails];
}

- (void)loadUserDetails
{
  editButton.enabled = NO;
  [LCAPIManager getUserDetailsOfUser:userDetail.userID WithSuccess:^(id response) {
    
    if(currentProfileState == PROFILE_SELF) {
      [LCUtilityManager saveUserDetailsToDataManagerFromResponse:response];
    }
    userDetail = response;
    editButton.enabled = YES;
    NSLog(@"user details - %@",response);
    
    userNameLabel.text = [[NSString stringWithFormat:@"%@ %@",
                           [LCUtilityManager performNullCheckAndSetValue:userDetail.firstName],
                           [LCUtilityManager performNullCheckAndSetValue:userDetail.lastName]] uppercaseString];
    memeberSincelabel.text = [NSString stringWithFormat:@"%@ %@",
                               NSLocalizedString(@"member_since", nil),
                              [LCUtilityManager getDateFromTimeStamp:userDetail.activationDate WithFormat:@"YYYY"]];
    
    locationLabel.text = [[NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                           [LCUtilityManager performNullCheckAndSetValue:userDetail.gender],
                           kBulletUnicode,
                           [LCUtilityManager getAgeFromTimeStamp:userDetail.dob],
                           kBulletUnicode,
                           [LCUtilityManager performNullCheckAndSetValue:userDetail.location]] uppercaseString];
    
    impactsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.impactCount];
    friendsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.friendCount];
    
    NSString *profileUrlString = [NSString stringWithFormat:@"%@?type=large",userDetail.avatarURL];
    
    [profilePic sd_setImageWithURL:[NSURL URLWithString:profileUrlString]
                  placeholderImage:profilePic.image];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?type=normal",userDetail.headerPhotoURL];
    
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString]
                       placeholderImage:headerImageView.image];
    
    
    switch ([userDetail.isFriend integerValue]) {
      case 0:
        currentProfileState = PROFILE_SELF;
        [editButton setImage:[UIImage imageNamed:kImageNameProfileSettings] forState:UIControlStateNormal];
        break;
        
      case 1:
        currentProfileState = PROFILE_OTHER_FRIEND;
        [editButton setImage:[UIImage imageNamed:kImageNameProfileFriend] forState:UIControlStateNormal];
        break;
        
      case 2:
        currentProfileState = PROFILE_OTHER_NON_FRIEND;
        [editButton setImage:[UIImage imageNamed:kImageNameProfileAdd] forState:UIControlStateNormal];
        break;
        
      case 3:
        currentProfileState = PROFILE_OTHER_WAITING;
        [editButton setImage:[UIImage imageNamed:kImageNameProfileWaiting] forState:UIControlStateNormal];
        break;
        
      default:
        break;
    }
    
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
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
  tabmenu.menuButtons = [[NSArray alloc] initWithObjects:mileStonesButton, interestsButton, actionsButton, nil];
  tabmenu.views = [[NSArray alloc] initWithObjects:milestonesContainer, interestsContainer, actionsContainer, nil];
  
  tabmenu.highlightColor = [UIColor colorWithRed:239.0f/255.0 green:100.0f/255.0 blue:77.0f/255.0 alpha:1.0];
  tabmenu.normalColor = [UIColor colorWithRed:40.0f/255.0 green:40.0f/255.0 blue:40.0f/255.0 alpha:1.0];
}


#pragma mark - Notification Receivers

-(void)updateUserData:(NSNotification *)notification {
  
  profilePic.image = (UIImage *)notification.userInfo[@"profilePic"];
  headerImageView.image = (UIImage *)notification.userInfo[@"headerBGImage"];
  dispatch_async(dispatch_get_global_queue(0,0), ^{
    [self loadUserDetails];
    
  });
}

-(void)updateFriendsCount:(NSNotification *)notification {
  
  NSString *status = notification.userInfo[@"status"];
  if ([status isEqualToString:@"deleted"]) {
    
    NSInteger count = [userDetail.friendCount integerValue] - 1;
    userDetail.friendCount = [NSString stringWithFormat: @"%ld", (long)count];
    friendsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.friendCount];
  }
}

-(void)updateImpactsCount:(NSNotification *)notification {
  
  NSString *status = notification.userInfo[@"status"];
  if ([status isEqualToString:@"deleted"]) {
    
    NSInteger count = [userDetail.impactCount integerValue] - 1;
    userDetail.impactCount = [NSString stringWithFormat: @"%ld", (long)count];
    impactsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.impactCount];
  }
}

#pragma mark - button actions
- (IBAction)friendsButtonClicked
{
  LCFriendsListViewController * friendsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCFriendsListVC"];
  friendsVC.userId = self.userDetail.userID;
  [self.navigationController pushViewController:friendsVC animated:YES];
}

- (IBAction)impactsButtonClicked
{
  NSLog(@"impacts clicked----->");
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
  LCImapactsViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LCImapactsViewController"];
  vc.userDetail = userDetail;
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backAction:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editClicked:(UIButton *)sender
{
  
  if (currentProfileState == PROFILE_SELF)
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
    LCProfileEditVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileEditVC"];
    vc.userDetail = self.userDetail;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navC animated:YES completion:nil];
  }
  else if (currentProfileState == PROFILE_OTHER_FRIEND)
  {
    //remove friend
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    actionSheet.view.tintColor = [UIColor blackColor];
    
    UIAlertAction *removeFriend = [UIAlertAction actionWithTitle:@"Remove Friend" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
      
      [LCAPIManager removeFriend:userDetail.userID withSuccess:^(NSArray *response)
       {
         NSLog(@"%@",response);
         currentProfileState = PROFILE_OTHER_NON_FRIEND;
         [editButton setImage:[UIImage imageNamed:kImageNameProfileAdd] forState:UIControlStateNormal];
       }
                      andFailure:^(NSString *error)
       {
         NSLog(@"%@",error);
       }];
    }];
    [actionSheet addAction:removeFriend];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
  }
  else if (currentProfileState == PROFILE_OTHER_NON_FRIEND)
  {
    //send friend request;
    
    [LCAPIManager sendFriendRequest:userDetail.userID withSuccess:^(NSArray *response) {
      NSLog(@"%@",response);
      currentProfileState = PROFILE_OTHER_WAITING;
      [editButton setImage:[UIImage imageNamed:kImageNameProfileWaiting] forState:UIControlStateNormal];
    } andFailure:^(NSString *error) {
      NSLog(@"%@",error);
    }];
  }
  else if (currentProfileState == PROFILE_OTHER_WAITING)
  {
    //cancel friend request
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    actionSheet.view.tintColor = [UIColor blackColor];
    
    UIAlertAction *cancelFreindRequest = [UIAlertAction actionWithTitle:@"Cancel Friend Request" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
      
      [LCAPIManager cancelFriendRequest:userDetail.userID withSuccess:^(NSArray *response) {
        NSLog(@"%@",response);
        currentProfileState = PROFILE_OTHER_NON_FRIEND;
        [editButton setImage:[UIImage imageNamed:kImageNameProfileAdd] forState:UIControlStateNormal];
      } andFailure:^(NSString *error) {
        NSLog(@"%@",error);
      }];
    }];
    [actionSheet addAction:cancelFreindRequest];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
  }
}

- (IBAction)mileStonesClicked:(id)sender
{
  [mileStonesVC startFetchingResults];
}

- (IBAction)interestsClicked:(id)sender
{
  [interestsVC loadInterests];
}

- (IBAction)actionsClicked:(id)sender
{
  [actionsVC loadActions];
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
