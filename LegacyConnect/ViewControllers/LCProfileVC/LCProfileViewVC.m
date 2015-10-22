//
//  LCProfileViewVC.m
//  LegacyConnect
//
//  Created by User on 7/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCProfileViewVC.h"
#import "LCTabMenuView.h"
#import "LCCommunityInterestCell.h"
#import "LCProfileEditVC.h"
#import "LCImapactsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCFriendsListViewController.h"
#import "LCFullScreenImageVC.h"
#import "LCCreatePostViewController.h"

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
  milestonesTable.estimatedRowHeight = 44.0;
  milestonesTable.rowHeight = UITableViewAutomaticDimension;
  
  UIView *zeroRectView = [[UIView alloc] initWithFrame:CGRectZero];
  milestonesTable.tableFooterView = zeroRectView;
  interestsTable.tableFooterView = zeroRectView;
  actionsTable.tableFooterView = zeroRectView;
  
  profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
  profilePicBorderView.layer.cornerRadius = profilePicBorderView.frame.size.width/2;
  
  [self loadUserInfo];
  
  [self loadMileStones];
  [self addTabMenu];
  
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonVisibilityStatus:NO MenuVisibilityStatus:NO];
  if (self.navigationController.viewControllers.count <= 1) {
    [backButton setHidden:YES];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserData:) name:kUserProfileUpdateNotification object:nil];
  
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonVisibilityStatus:YES MenuVisibilityStatus:YES];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserProfileUpdateNotification object:nil];
}


#pragma mark - setup functions

- (void) loadUserInfo {
  
  userNameLabel.text = @"";
  memeberSincelabel.text = @"";
  locationLabel.text = @"";
  
  //for testing as user ID is not persisting
  NSString *nativeUserId = [LCDataManager sharedDataManager].userID;
  NSLog(@"nativeUserId-->>%@ userDetail.userID-->>%@",nativeUserId, userDetail.userID);
  if ([nativeUserId isEqualToString:userDetail.userID] || !userDetail.userID)
  {
    currentProfileState = PROFILE_SELF;
    [editButton setImage:[UIImage imageNamed:kImageNameProfileSettings] forState:UIControlStateNormal];
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
  
  NSLog(@"userID<<<-->>>%@", userDetail.userID);
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
                          [LCUtilityManager performNullCheckAndSetValue:userDetail.lastName]]uppercaseString];
    memeberSincelabel.text = [NSString stringWithFormat:@"Member Since %@",
                              [LCUtilityManager getDateFromTimeStamp:userDetail.activationDate WithFormat:@"YYYY"]];
    
    locationLabel.text = [[NSString stringWithFormat:@"%@ \u2022 %@ \u2022 %@",
                          [LCUtilityManager performNullCheckAndSetValue:userDetail.gender],
                          [LCUtilityManager getAgeFromTimeStamp:userDetail.dob],
                          [LCUtilityManager performNullCheckAndSetValue:userDetail.location]] uppercaseString];
    
    impactsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.impactCount];
    friendsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.friendCount];
    
    NSString *profileUrlString = [NSString stringWithFormat:@"%@?type=normal",userDetail.avatarURL];
    
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

-(void)updateUserData:(NSNotification *)notification {
  profilePic.image = (UIImage *)notification.userInfo[@"profilePic"];
  headerImageView.image = (UIImage *)notification.userInfo[@"headerBGImage"];
  dispatch_async(dispatch_get_global_queue(0,0), ^{
    [self loadUserDetails];
    
  });
  
}


- (void)addTabMenu
{
  LCTabMenuView *tabmenu = [[LCTabMenuView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
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
  tabmenu.views = [[NSArray alloc] initWithObjects:milestonesTable,  interestsTable, actionsTable, nil];
  
  tabmenu.highlightColor = [UIColor colorWithRed:239.0f/255.0 green:100.0f/255.0 blue:77.0f/255.0 alpha:1.0];
  tabmenu.normalColor = [UIColor colorWithRed:40.0f/255.0 green:40.0f/255.0 blue:40.0f/255.0 alpha:1.0];
}

-(void)loadMileStones
{
  [MBProgressHUD showHUDAddedTo:milestonesTable animated:YES];
  [LCAPIManager getMilestonesForUser:userDetail.userID
                  andLastMilestoneID:nil withSuccess:^(NSArray *response) {
                    mileStoneFeeds = response;
                    [milestonesTable reloadData];
                    [MBProgressHUD hideAllHUDsForView:milestonesTable animated:YES];
                  }
                          andFailure:^(NSString *error) {
                            [MBProgressHUD hideAllHUDsForView:milestonesTable animated:YES];
                            NSLog(@"%@",error);
                          }];
}


- (void)loadInterests
{
  [MBProgressHUD showHUDAddedTo:interestsTable animated:YES];
  [LCAPIManager getInterestsForUser:userDetail.userID withSuccess:^(NSArray *responses) {
    interestsArray = responses;
    [interestsTable reloadData];
    [MBProgressHUD hideAllHUDsForView:interestsTable animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:interestsTable animated:YES];
    NSLog(@"%@",error);
  }];
}

- (void) loadEvents {
  [MBProgressHUD showHUDAddedTo:actionsTable animated:YES];
  

  [LCAPIManager getUserEventsForUserId:userDetail.userID andLastEventId:nil withSuccess:^(NSArray *response) {
    
    actionsArray = response;
    [actionsTable reloadData];
    [MBProgressHUD hideAllHUDsForView:actionsTable animated:YES];
  } andFailure:^(NSString *error) {
    
    [MBProgressHUD hideAllHUDsForView:actionsTable animated:YES];
  }];
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
  [LCUtilityManager setGIAndMenuButtonVisibilityStatus:NO MenuVisibilityStatus:NO];
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)mileStonesClicked:(id)sender
{
  [self loadMileStones];
}

- (IBAction)interestsClicked:(id)sender
{
  [self loadInterests];
}

- (IBAction)actionsClicked:(id)sender
{
  [self loadEvents];
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

#pragma mark - scrollview delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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


#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (tableView == milestonesTable) {
    if (mileStoneFeeds.count == 0) {
      return 1;
    }
    return mileStoneFeeds.count;
  }
  else if (tableView == interestsTable) {
    if (interestsArray.count == 0) {
      return 1;
    }
    return interestsArray.count;
  }
  else if (tableView == actionsTable) {
    if (actionsArray.count == 0) {
      return 1;
    }
    return actionsArray.count;
  }
  
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView == milestonesTable) {
    
    //MILESTONES
    if (mileStoneFeeds.count == 0) {
      
      NSString *message;
      if (currentProfileState == PROFILE_SELF) {
        message = @"Tap \"...\" in any of your posts to add as a milestone.";
        
      }
      else {
        message = @"No milestones available.";
      }
      UITableViewCell *cell = [LCUtilityManager getEmptyIndicationCellWithText:message];
      
      tableView.backgroundColor = [UIColor whiteColor];
      tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      tableView.allowsSelection = NO;
      return cell;
    }
    
    else {
      
      LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:[LCFeedCellView getFeedCellIdentifier]];
      if (cell == nil)
      {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
      }
      [cell setData:[mileStoneFeeds objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
      __weak typeof(self) weakSelf = self;
      cell.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
        [weakSelf feedCellActionWithType:actionType andFeed:feed];
      };
      cell.feedCellTagAction = ^ (NSDictionary * tagDetails) {
        [weakSelf tagTapped:tagDetails];
      };

      
      if (currentProfileState == PROFILE_SELF) {
        cell.moreButton.hidden = NO;
      }
      
      tableView.backgroundColor = [UIColor clearColor];
      tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
      tableView.allowsSelection = YES;
      
      return cell;
    }
    
  }
  else if (tableView == interestsTable){
    
    //INTERESTS
    if (interestsArray.count == 0) {
      
      NSString *message;
      if (currentProfileState == PROFILE_SELF) {
        message = @"Search and add interests from the menu.";
        
      }
      else {
        message = @"No interests available.";
      }
      UITableViewCell *cell = [LCUtilityManager getEmptyIndicationCellWithText:message];
      
      tableView.backgroundColor = [UIColor whiteColor];
      tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      tableView.allowsSelection = NO;
      return cell;
    }
    else {
      static NSString *MyIdentifier = @"LCInterestsCell";
      LCInterestsCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
      if (cell == nil)
      {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCInterestsCellView" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
      }
      
      LCInterest *interstObj = [interestsArray objectAtIndex:indexPath.row];
      [cell setData:interstObj];
      
      tableView.backgroundColor = [UIColor clearColor];
      tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
      tableView.allowsSelection = YES;
      
      return cell;
    }
  }
  
  else if (tableView == actionsTable)
  {
    //ACTIONS
    if (actionsArray.count == 0) {
      
      NSString *message;
      if (currentProfileState == PROFILE_SELF) {
        message = @"Take action by selecting the Global Impact button from the bottom right.";
        
      }
      else {
        message = @"No actions available.";
      }
      UITableViewCell *cell = [LCUtilityManager getEmptyIndicationCellWithText:message];
      
      tableView.backgroundColor = [UIColor whiteColor];
      tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      tableView.allowsSelection = NO;
      return cell;
    }
    else {
      static NSString *MyIdentifier = @"LCActionsCell";
      LCActionsCellView *cell = (LCActionsCellView*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
      if (cell == nil)
      {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCActionsCellView" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
      }
      [cell setEvent:[actionsArray objectAtIndex:indexPath.row]];
      
      tableView.backgroundColor = [UIColor clearColor];
      tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
      tableView.allowsSelection = YES;
      return cell;
    }
  }
  
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
{
  switch (type) {
    case kkFeedCellActionLoadMore:
      [self feedCellMoreAction :feed];
      break;
      
      case kkFeedCellActionViewImage:
      [self showFullScreenImage:feed];
      break;
      
    default:
      break;
  }
}

- (void)showFullScreenImage:(LCFeed*)feed
{
  [LCUtilityManager setGIAndMenuButtonVisibilityStatus:YES MenuVisibilityStatus:YES];
  LCFullScreenImageVC *vc = [[LCFullScreenImageVC alloc] init];
  vc.imageUrlString = feed.image;
  vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)feedCellMoreAction :(LCFeed *)feed
{
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  actionSheet.view.tintColor = [UIColor blackColor];
  
  UIAlertAction *editPost = [UIAlertAction actionWithTitle:@"Edit Post" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    UIStoryboard*  story_board = [UIStoryboard storyboardWithName:kCreatePostStoryBoardIdentifier bundle:nil];
    LCCreatePostViewController * createPostVC = [story_board instantiateInitialViewController];
    createPostVC.isEditing = YES;
    createPostVC.postFeedObject = feed;
    createPostVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:createPostVC animated:YES completion:nil];
    LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
    appdel.isCreatePostOpen = false;
  }];
  
  [actionSheet addAction:editPost];
  
  UIAlertAction *removeMilestone = [UIAlertAction actionWithTitle:@"Remove Milestone" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [MBProgressHUD showHUDAddedTo:milestonesTable animated:YES];
    [LCAPIManager removeMilestoneFromPost:feed.entityID withSuccess:^(NSArray *response) {
      [MBProgressHUD hideAllHUDsForView:milestonesTable animated:YES];
    }
    andFailure:^(NSString *error) {
     [MBProgressHUD hideAllHUDsForView:milestonesTable animated:YES];
      NSLog(@"%@",error);
    }];
  }];
  [actionSheet addAction:removeMilestone];
  
  UIAlertAction *deletePost = [UIAlertAction actionWithTitle:@"Delete Post" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    [MBProgressHUD showHUDAddedTo:milestonesTable animated:YES];
    [LCAPIManager deletePost:feed.entityID withSuccess:^(NSArray *response) {
      [MBProgressHUD hideAllHUDsForView:milestonesTable animated:YES];
    }
    andFailure:^(NSString *error) {
      [MBProgressHUD hideAllHUDsForView:milestonesTable animated:YES];
                                 NSLog(@"%@",error);
    }];
  }];
  [actionSheet addAction:deletePost];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  [actionSheet addAction:cancelAction];
  [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  NSLog(@"tag details-->>%@", tagDetails);
}

@end
