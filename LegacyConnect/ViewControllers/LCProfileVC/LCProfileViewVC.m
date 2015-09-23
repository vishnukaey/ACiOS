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
  profilePic.layer.borderWidth = 3.0f;
  profilePic.layer.borderColor = [[UIColor colorWithRed:247.0f/255.0 green:247.0f/255.0 blue:247.0f/255.0 alpha:0.5] CGColor];
  
  friendsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  impactsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  
  backButton.hidden = true;
 
  
  [self addTabMenu];
  
  [self loadUserDetails];
  
  [self loadMileStones];
  [self loadInterests];
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
- (void)loadUserDetails
{
  
  //for testing as user ID is not persisting
  NSString *nativeUserId = [LCDataManager sharedDataManager].userID;// @"6994";
  NSLog(@"nativeUserId-->>%@ userDetail.userID-->>%@",nativeUserId, userDetail.userID);
  if ([nativeUserId isEqualToString:userDetail.userID])
  {
    [editButton setImage:[UIImage imageNamed:@"profileSettings.png"] forState:UIControlStateNormal];
    currentProfileState = PROFILE_SELF;
  }
  else
  {
    backButton.hidden = false;
    [editButton setImage:[UIImage imageNamed:@"profileAdd.png"] forState:UIControlStateNormal];
    currentProfileState = PROFILE_OTHER_NON_FRIEND;
  }
  //  userDetail.userID = @"6875";
  NSLog(@"userID<<<-->>>%@", userDetail.userID);
  [LCAPIManager getUserDetailsOfUser:userDetail.userID WithSuccess:^(id response) {
    userDetail = response;
    NSLog(@"%@",response);
    [profilePic sd_setImageWithURL:[NSURL URLWithString:userDetail.avatarURL] placeholderImage:[UIImage imageNamed:@"manplaceholder.jpg"]];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:userDetail.headerPhotoURL] placeholderImage:[UIImage imageNamed:@"landscape_valley_sunset_lone_tree_high_resolution_wallpapers-320x568.jpg"]];
    userNameLabel.text = [NSString stringWithFormat:@"%@ %@", userDetail.firstName, userDetail.lastName];
    memeberSincelabel.text = [NSString stringWithFormat:@"Member Since %@", userDetail.activationDate];
    locationLabel.text = [NSString stringWithFormat:@"%@. %@. %@", userDetail.gender, userDetail.dob, userDetail.location];
    
    if ([userDetail.isFriend isEqualToString:@"Friend request pending"])
    {
      [editButton setImage:[UIImage imageNamed:@"profileWaiting.png"] forState:UIControlStateNormal];
      currentProfileState = PROFILE_OTHER_WAITING;
    }
    
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
}

- (void)addTabMenu
{
  UIButton *mileStonesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [mileStonesButton setTitle:@"MILESTONES" forState:UIControlStateNormal];
  UIButton *interestsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [interestsButton setTitle:@"INTERESTS" forState:UIControlStateNormal];
  UIButton *actionsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [actionsButton setTitle:@"ACTIONS" forState:UIControlStateNormal];
  
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
  tabmenu.views = [[NSArray alloc] initWithObjects:milestonesTable,  interestsTable, actionsView, nil];
  
  tabmenu.highlightColor = [UIColor colorWithRed:239.0f/255.0 green:100.0f/255.0 blue:77.0f/255.0 alpha:1.0];
  tabmenu.normalColor = [UIColor colorWithRed:40.0f/255.0 green:40.0f/255.0 blue:40.0f/255.0 alpha:1.0];
}

- (void)loadInterests
{
  [LCAPIManager getInterestsWithSuccess:^(NSArray *response)
   {
     NSLog(@"%@",response);
     interestsArray = response;
     [interestsTable reloadData];
     
   }
                             andFailure:^(NSString *error)
   {
     NSLog(@"%@",error);
   }
   ];
}


-(void)loadMileStones
{
  [LCAPIManager getHomeFeedsWithSuccess:^(NSArray *response) {
    mileStoneFeeds = response;
    [milestonesTable reloadData];
  } andFailure:^(NSString *error) {
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

-(void)interestClicked :(UIButton *)sender
{
  NSLog(@"interest clicked----->");
}

- (IBAction)editClicked:(UIButton *)sender
{
  
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kProfileStoryBoardIdentifier bundle:nil];
  LCProfileEditVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileEditVC"];
  vc.userDetail = self.userDetail;
  //[self.navigationController pushViewController:vc animated:YES];
  [self presentViewController:vc animated:YES completion:nil];
  
  if (currentProfileState == PROFILE_SELF)
  {
    NSLog(@"go to settings-->>");
    //    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    //    LCUserFriendsVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileEditVC"];
    //    [self.navigationController pushViewController:vc animated:YES];
  }
  else if (currentProfileState == PROFILE_OTHER_FRIEND)
  {
    [editButton setImage:[UIImage imageNamed:@"profileAdd.png"] forState:UIControlStateNormal];
    currentProfileState = PROFILE_OTHER_NON_FRIEND;
    NSLog(@"remove friend-->>");
  }
  else if (currentProfileState == PROFILE_OTHER_NON_FRIEND)
  {
    NSLog(@"send friend request-->>");
    LCFriend *friend = [[LCFriend alloc] init];
    friend.userID = userDetail.userID;
    friend.firstName = userDetail.firstName;
    friend.lastName = userDetail.lastName;
    friend.avatarURL = userDetail.avatarURL;
    [LCAPIManager sendFriendRequest:friend withSuccess:^(NSArray *response) {
      NSLog(@"%@",response);
      [editButton setImage:[UIImage imageNamed:@"profileWaiting.png"] forState:UIControlStateNormal];
      currentProfileState = PROFILE_OTHER_WAITING;
    } andFailure:^(NSString *error) {
      NSLog(@"%@",error);
    }];
  }
  else if (currentProfileState == PROFILE_OTHER_WAITING)
  {
    NSLog(@"cancel invitation-->>");
    LCFriend *friend = [[LCFriend alloc] init];
    friend.userID = userDetail.userID;
    friend.firstName = userDetail.firstName;
    friend.lastName = userDetail.lastName;
    friend.avatarURL = userDetail.avatarURL;
    //    [LCAPIManager ca:friend withSuccess:^(NSArray *response) {
    //      NSLog(@"%@",response);
    //      [editButton setImage:[UIImage imageNamed:@"profileAdd.png"] forState:UIControlStateNormal];
    //      currentProfileState = PROFILE_OTHER_NON_FRIEND;
    //    } andFailure:^(NSString *error) {
    //      NSLog(@"%@",error);
    //    }];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (tableView == milestonesTable) {
    return mileStoneFeeds.count;
  }
  else if (tableView == interestsTable) {
    return interestsArray.count;
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
  else {
    
    static NSString *MyIdentifier = @"interestsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    LCInterest *interstObj = [interestsArray objectAtIndex:indexPath.row];
    
    UILabel *interestNameLabel = (UILabel*)[cell viewWithTag:102];
    interestNameLabel.text = interstObj.name;
    
    UILabel *interestFollowLabel = (UILabel*)[cell viewWithTag:103];
    interestFollowLabel.text = [NSString stringWithFormat:@"Followed by %@ people",interstObj.followers];
  
    return cell;
  }
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
