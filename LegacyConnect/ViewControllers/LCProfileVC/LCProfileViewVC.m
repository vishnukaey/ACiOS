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

@implementation LCProfileViewVC
@synthesize userDetail;

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  milestonesTable.estimatedRowHeight = 44.0;
  milestonesTable.rowHeight = UITableViewAutomaticDimension;
  
  profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
  profilePicBorderView.layer.cornerRadius = profilePicBorderView.frame.size.width/2;
  
  [self loadEmptyDetails];
  [self loadUserDetails];
  [self loadMileStones];
  //[self loadInterests];
  
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
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [appdel.menuButton setHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}


#pragma mark - setup functions

- (void) loadEmptyDetails {
  
  userNameLabel.text = @"";
  memeberSincelabel.text = @"";
  locationLabel.text = @"";
  
}


- (void)loadUserDetails
{
  
  //for testing as user ID is not persisting
  NSString *nativeUserId = [LCDataManager sharedDataManager].userID;
  NSLog(@"nativeUserId-->>%@ userDetail.userID-->>%@",nativeUserId, userDetail.userID);
  if ([nativeUserId isEqualToString:userDetail.userID])
  {
    currentProfileState = PROFILE_SELF;
    [editButton setImage:[UIImage imageNamed:@"profileSettings"] forState:UIControlStateNormal];
    backButton.hidden = YES;
  }
  else
  {
    currentProfileState = PROFILE_OTHER_NON_FRIEND;
    [editButton setImage:[UIImage imageNamed:@"profileAdd"] forState:UIControlStateNormal];
  }
  
  NSLog(@"userID<<<-->>>%@", userDetail.userID);
  [LCAPIManager getUserDetailsOfUser:userDetail.userID WithSuccess:^(id response) {
    userDetail = response;
    NSLog(@"user details - %@",response);
    
    userNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                          [LCUtilityManager performNullCheckAndSetValue:userDetail.firstName],
                          [LCUtilityManager performNullCheckAndSetValue:userDetail.lastName]];
    memeberSincelabel.text = [NSString stringWithFormat:@"Member Since %@",
                              [LCUtilityManager getDateFromTimeStamp:userDetail.activationDate WithFormat:@"YYYY"]];
    
    locationLabel.text = [NSString stringWithFormat:@"%@ . %@ . %@",
                          [LCUtilityManager performNullCheckAndSetValue:userDetail.gender],
                          [LCUtilityManager getAgeFromTimeStamp:userDetail.dob],
                          [LCUtilityManager performNullCheckAndSetValue:userDetail.location]];
    
    impactsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.impactCount];
    friendsCountLabel.text = [LCUtilityManager performNullCheckAndSetValue:userDetail.friendCount];
    
    
    [profilePic sd_setImageWithURL:[NSURL URLWithString:userDetail.avatarURL]
                  placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:userDetail.headerPhotoURL]
                       placeholderImage:nil];
    
    if ([userDetail.isFriend isEqualToString:@"Friend request pending"])
    {
      [editButton setImage:[UIImage imageNamed:@"profileWaiting"] forState:UIControlStateNormal];
      currentProfileState = PROFILE_OTHER_WAITING;
    }
    
    switch ([userDetail.isFriend integerValue]) {
      case 0:
        currentProfileState = PROFILE_SELF;
        [editButton setImage:[UIImage imageNamed:@"profileSettings"] forState:UIControlStateNormal];
        backButton.hidden = YES;
        break;
        
      case 1:
        currentProfileState = PROFILE_OTHER_FRIEND;
        [editButton setImage:[UIImage imageNamed:@"profileFriend"] forState:UIControlStateNormal];
        break;
        
      case 2:
        currentProfileState = PROFILE_OTHER_NON_FRIEND;
        [editButton setImage:[UIImage imageNamed:@"profileAdd"] forState:UIControlStateNormal];
        break;
        
      case 3:
        currentProfileState = PROFILE_OTHER_WAITING;
        [editButton setImage:[UIImage imageNamed:@"profileWaiting"] forState:UIControlStateNormal];
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
  
  LCTabMenuView *tabmenu = [[LCTabMenuView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [tabMenuContainer addSubview:tabmenu];
  [tabmenu setBackgroundColor:[UIColor whiteColor]];
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
                  andLastMilestoneID:nil with:^(NSArray *response) {
                    mileStoneFeeds = response;
                    [milestonesTable reloadData];
                    [MBProgressHUD hideHUDForView:milestonesTable animated:YES];
                  }
                          andFailure:^(NSString *error) {
                            [MBProgressHUD hideHUDForView:milestonesTable animated:YES];
                            NSLog(@"%@",error);
                          }];
  
//  [LCAPIManager getHomeFeedsWithSuccess:^(NSArray *response) {
//    mileStoneFeeds = response;
//    [milestonesTable reloadData];
//    [MBProgressHUD hideHUDForView:milestonesTable animated:YES];
//  } andFailure:^(NSString *error) {
//    [MBProgressHUD hideHUDForView:milestonesTable animated:YES];
//    NSLog(@"%@",error);
//  }];
}

- (void)loadInterests
{
  [MBProgressHUD showHUDAddedTo:interestsTable animated:YES];
  
  [LCAPIManager getInterestsWithSuccess:^(NSArray *response)
   {
     //NSLog(@"%@",response);
     interestsArray = response;
     [interestsTable reloadData];
     [MBProgressHUD hideHUDForView:interestsTable animated:YES];
   }
                             andFailure:^(NSString *error)
   {
     [MBProgressHUD hideHUDForView:interestsTable animated:YES];
     NSLog(@"%@",error);
   }
   ];
}

- (void) loadEvents {
  
//  [MBProgressHUD showHUDAddedTo:actionsTable animated:YES];
//  
//  [LCAPIManager getEventDetailsForEventWithID:userDetail.userID withSuccess:^(NSArray *response)
//   {
//     //NSLog(@"%@",response);
////     interestsArray = response;
////     [interestsTable reloadData];
//     [MBProgressHUD hideHUDForView:interestsTable animated:YES];
//   }
//                                   andFailure:^(NSString *error)
//   {
//     [MBProgressHUD hideHUDForView:interestsTable animated:YES];
//     NSLog(@"%@",error);
//   }
//   ];
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
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backAction:(id)sender
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
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
    userDetail.firstName = @"pr";
    [LCAPIManager updateProfile:userDetail havingHeaderPhoto:nil removedState:NO andAvtarImage:[UIImage imageNamed:@"backButton.png"] removedState:NO withSuccess:^(NSArray *response) {
      NSLog(@"ress-->>>%@",response);
      [MBProgressHUD hideHUDForView:milestonesTable animated:YES];
    } andFailure:^(NSString *error) {
      [MBProgressHUD hideHUDForView:milestonesTable animated:YES];
      NSLog(@"%@",error);
    }];
//    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
//    LCProfileEditVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileEditVC"];
//    vc.userDetail = self.userDetail;
//    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:navC animated:YES completion:nil];
  }
  else if (currentProfileState == PROFILE_OTHER_FRIEND)
  {
    //remove friend
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    actionSheet.view.tintColor = [UIColor blackColor];
    
    UIAlertAction *removeFriend = [UIAlertAction actionWithTitle:@"Remove Friend" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
      
      LCFriend *friend = [[LCFriend alloc] init];
      friend.userID = userDetail.userID;
      
      [LCAPIManager removeFriend:friend withSuccess:^(NSArray *response)
       {
         NSLog(@"%@",response);
         currentProfileState = PROFILE_OTHER_NON_FRIEND;
         [editButton setImage:[UIImage imageNamed:@"profileAdd"] forState:UIControlStateNormal];
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
    //send friend request
    LCFriend *friend = [[LCFriend alloc] init];
    friend.userID = userDetail.userID;
    
    [LCAPIManager sendFriendRequest:friend withSuccess:^(NSArray *response) {
      NSLog(@"%@",response);
      currentProfileState = PROFILE_OTHER_WAITING;
      [editButton setImage:[UIImage imageNamed:@"profileWaiting"] forState:UIControlStateNormal];
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
      
      LCFriend *friend = [[LCFriend alloc] init];
      friend.userID = userDetail.userID;
      
      [LCAPIManager cancelFriendRequest:friend withSuccess:^(NSArray *response) {
        NSLog(@"%@",response);
        currentProfileState = PROFILE_OTHER_NON_FRIEND;
        [editButton setImage:[UIImage imageNamed:@"profileAdd"] forState:UIControlStateNormal];
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
    return 5;
  }
  
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView == milestonesTable) {
    
    //MILESTONES
    if (mileStoneFeeds.count == 0) {
      
      UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
      if (currentProfileState == PROFILE_SELF) {
        cell.textLabel.text = @"Tap \"...\" in any of your posts to add as a milestone.";
      }
      else {
        cell.textLabel.text = @"No milestones available.";
      }
      cell.textLabel.textAlignment =NSTextAlignmentCenter;
      cell.textLabel.numberOfLines = 3;
      
      tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      tableView.allowsSelection = NO;
      return cell;
    }
    
    else {
      
      static NSString *MyIdentifier = @"LCFeedCell";
      LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
      if (cell == nil)
      {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
      }
      cell.delegate = self;
      [cell setData:[mileStoneFeeds objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
      
      if (currentProfileState == PROFILE_SELF) {
        cell.moreButton.hidden = NO;
      }
      
      return cell;
    }
    
  }
  else if (tableView == interestsTable){
    
    //INTERESTS
    if (interestsArray.count == 0) {
      
      UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
      if (currentProfileState == PROFILE_SELF) {
        cell.textLabel.text = @"Search and add interests from the menu.";
      }
      else {
        cell.textLabel.text = @"No interests available.";
      }
      cell.textLabel.textAlignment =NSTextAlignmentCenter;
      cell.textLabel.numberOfLines = 3;
      
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
      
      cell.interestNameLabel.text = [LCUtilityManager performNullCheckAndSetValue:interstObj.name];
      
      cell.interestFollowLabel.text = [NSString stringWithFormat:@"Followed by %ld people",
                                       [interstObj.followers integerValue]];
      [cell.interestsBG sd_setImageWithURL:[NSURL URLWithString:interstObj.logoURLLarge]
                          placeholderImage:nil];
      
      return cell;
    }
  }
  
  else if (tableView == actionsTable){
    
    //ACTIONS
    static NSString *MyIdentifier = @"LCActionsCell";
    LCActionsCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCActionsCellView" owner:self options:nil];
      cell = [topLevelObjects objectAtIndex:0];
    }
    
    return cell;
  }
  
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(NSString *)type andFeed:(LCFeed *)feed
{
  NSLog(@"actionType--->>>%@", type);
  if (type == kFeedCellActionMore) {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    actionSheet.view.tintColor = [UIColor blackColor];
    
    UIAlertAction *editPost = [UIAlertAction actionWithTitle:@"Edit Post" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      
    }];
    
    [actionSheet addAction:editPost];
    
    UIAlertAction *removeMilestone = [UIAlertAction actionWithTitle:@"Remove Milestone" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      
    }];
    [actionSheet addAction:removeMilestone];
    
    UIAlertAction *deletePost = [UIAlertAction actionWithTitle:@"Delete Post" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
      
    }];
    [actionSheet addAction:deletePost];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
  }
  
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  NSLog(@"tag details-->>%@", tagDetails);
}

@end
