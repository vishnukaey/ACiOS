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
#import "LCUserFriendsVC.h"
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
  
  friendsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  impactsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  
  backButton.hidden = true;
  
  [self addTabMenu];
  
  [self loadEmptyDetails];
  [self loadUserDetails];
  [self loadMileStones];
  //[self loadInterests];
  
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
    [editButton setImage:[UIImage imageNamed:@"profileSettings"] forState:UIControlStateNormal];
    currentProfileState = PROFILE_SELF;
  }
  else
  {
    backButton.hidden = NO;
    [editButton setImage:[UIImage imageNamed:@"profileAdd"] forState:UIControlStateNormal];
    currentProfileState = PROFILE_OTHER_NON_FRIEND;
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
    
    [profilePic sd_setImageWithURL:[NSURL URLWithString:userDetail.avatarURL]
                  placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:userDetail.headerPhotoURL]
                       placeholderImage:[UIImage imageNamed:@"headerImage"]];
    
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
  
  
  if ([userDetail.isFriend isEqualToString:@"Friend request pending"])
  {
    [editButton setImage:[UIImage imageNamed:@"profileWaiting"] forState:UIControlStateNormal];
    currentProfileState = PROFILE_OTHER_WAITING;
  }
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

- (void)loadInterests
{
  [MBProgressHUD showHUDAddedTo:interestsTable animated:YES];
  [LCAPIManager getInterestsWithSuccess:^(NSArray *response)
   {
     NSLog(@"%@",response);
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


-(void)loadMileStones
{
  [MBProgressHUD showHUDAddedTo:milestonesTable animated:YES];
  
  [LCAPIManager getHomeFeedsWithSuccess:^(NSArray *response) {
    mileStoneFeeds = response;
    [milestonesTable reloadData];
    [MBProgressHUD hideHUDForView:milestonesTable animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:milestonesTable animated:YES];
    NSLog(@"%@",error);
  }];
}


#pragma mark - button actions

- (IBAction)friendsButtonClicked
{
  
  LCFriendsListViewController * friendsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCFriendsListVC"];
  friendsVC.userId = self.userDetail.userID;
  [self.navigationController pushViewController:friendsVC animated:YES];
  
//  NSLog(@"friends clicked----->");
//  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
//  LCUserFriendsVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCUserFriendsVC"];
//  [self.navigationController pushViewController:vc animated:YES];
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
    LCFriend *friend = [[LCFriend alloc] init];
    friend.userID = userDetail.userID;
    friend.firstName = userDetail.firstName;
    friend.lastName = userDetail.lastName;
    friend.avatarURL = userDetail.avatarURL;
    
    [LCAPIManager removeFried:friend withSuccess:^(NSArray *response)
    {
      NSLog(@"%@",response);
      [editButton setImage:[UIImage imageNamed:@"profileAdd"] forState:UIControlStateNormal];
      currentProfileState = PROFILE_OTHER_NON_FRIEND;
    }
    andFailure:^(NSString *error)
    {
      NSLog(@"%@",error);
    }];
  }
  else if (currentProfileState == PROFILE_OTHER_NON_FRIEND)
  {
    //send friend request
    LCFriend *friend = [[LCFriend alloc] init];
    friend.userID = userDetail.userID;
    friend.firstName = userDetail.firstName;
    friend.lastName = userDetail.lastName;
    friend.avatarURL = userDetail.avatarURL;
    
    [LCAPIManager sendFriendRequest:friend withSuccess:^(NSArray *response) {
      NSLog(@"%@",response);
      [editButton setImage:[UIImage imageNamed:@"profileWaiting"] forState:UIControlStateNormal];
      currentProfileState = PROFILE_OTHER_WAITING;
    } andFailure:^(NSString *error) {
      NSLog(@"%@",error);
    }];
  }
  else if (currentProfileState == PROFILE_OTHER_WAITING)
  {
    //cancel friend request
    LCFriend *friend = [[LCFriend alloc] init];
    friend.userID = userDetail.userID;
    friend.firstName = userDetail.firstName;
    friend.lastName = userDetail.lastName;
    friend.avatarURL = userDetail.avatarURL;
    
    [LCAPIManager cancelFriendRequest:friend withSuccess:^(NSArray *response) {
      NSLog(@"%@",response);
      [editButton setImage:[UIImage imageNamed:@"profileAdd"] forState:UIControlStateNormal];
      currentProfileState = PROFILE_OTHER_NON_FRIEND;
    } andFailure:^(NSString *error) {
      NSLog(@"%@",error);
    }];
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
    return mileStoneFeeds.count;
  }
  else if (tableView == interestsTable) {
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
    
    return cell;
    
  }
  else if (tableView == interestsTable){
    
    static NSString *MyIdentifier = @"LCInterestsCell";
    LCInterestsCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCInterestsCellView" owner:self options:nil];
      cell = [topLevelObjects objectAtIndex:0];

    }
    
    LCInterest *interstObj = [interestsArray objectAtIndex:indexPath.row];
    
    cell.interestNameLabel.text = [LCUtilityManager performNullCheckAndSetValue:interstObj.name];
    cell.interestFollowLabel.text = [NSString stringWithFormat:@"Followed by %@ people",
                                     [LCUtilityManager performNullCheckAndSetValue:interstObj.followers]];
    [cell.interestsBG sd_setImageWithURL:[NSURL URLWithString:interstObj.logoURLLarge]
                        placeholderImage:[UIImage imageNamed:@"headerImage"]];

    return cell;
  }
  
  else if (tableView == actionsTable){
    
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
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  NSLog(@"tag details-->>%@", tagDetails);
}

@end
