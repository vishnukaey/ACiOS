//
//  LCViewActions.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCViewActions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCCommentCell.h"
#import "LCSingleCauseVC.h"
#import "LCProfileViewVC.h"
#import "LCActionsForm.h"
#import "LCActionsFormPresenter.h"
#import "LCEventMembersViewController.h"
#import "LCActionsHeader.h"
#import "NSURL+LCURLCategory.h"

static CGFloat kActionSectionHeight = 30;

#define kActionsHeaderBG [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1]
#define kActionsHeaderText [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1]
#define kActionsHeaderTextFont [UIFont fontWithName:@"Gotham-Medium" size:11]

#pragma mark - LCCommunityDetailCell class
@interface LCActionsDetailsCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *communityDetailsLabel;
@end

@implementation LCActionsDetailsCell
@end

#pragma mark - LCCommunityMemebersCountCell class
@interface LCActionsMembersCountCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *communityMemebersCountLabel;
@property(nonatomic, strong)IBOutlet UIImageView *seperator;
@end

@implementation LCActionsMembersCountCell
@end

#pragma mark - LCActionDateCell class
@interface LCActionDateCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UILabel *eventDateLabel;
@end

@implementation LCActionDateCell
@end

#pragma mark - LCCommunityWebsiteCell class
@interface LCActionsWebsiteCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *communityWebsiteLabel;
@end

@implementation LCActionsWebsiteCell
@end

#pragma mark - LCViewActions class implementation
@implementation LCViewActions

#pragma mark - Event Comments API and pagination
- (void)startFetchingResults
{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [super startFetchingResults];
  [LCAPIManager getCommentsForEvent:self.eventObject.eventID lastCommentID:nil withSuccess:^(id response, BOOL isMore) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self didFetchResults:response haveMoreData:isMore];
  } andfailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self didFailedToFetchResults];
  }];
}

- (void)startFetchingNextResults
{
  [super startFetchingNextResults];
  [LCAPIManager getCommentsForEvent:self.eventObject.eventID lastCommentID:[(LCComment*)[self.results lastObject] commentId] withSuccess:^(id response, BOOL isMore) {
    [self didFetchNextResults:response haveMoreData:isMore];
  } andfailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

#pragma mark - Event Details API call
-(void)getEventDetails
{
  [LCAPIManager getEventDetailsForEventWithID:self.eventObject.eventID withSuccess:^(LCEvent *responses) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.eventObject = responses;
    [self dataPopulation];
    if ((self.eventObject.isFollowing || self.eventObject.isOwner)  && self.results.count ==0) {
      [self startFetchingResults];
    }
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dataPopulation];
    if ((self.eventObject.isFollowing || self.eventObject.isOwner)  && self.results.count ==0) {
      [self startFetchingResults];
    }
    LCDLog(@"%@",error);
  }];
}

- (void)postAction
{
  NSString * commentString = [commentTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
;
  if (commentString.length > 0) {
    [self resignAllResponders];
    [self enableCommentField:NO];
    [LCAPIManager postCommentToEvent:self.eventObject.eventID comment:commentTextField.text withSuccess:^(id response) {
      [self.results insertObject:(LCComment*)response atIndex:0];
      [commentTextField setText:nil];
      [commentTextField_dup setText:nil];
      [self changeUpdateButtonState];
      [self.tableView reloadData];
      [self enableCommentField:YES];
    } andFailure:^(NSString *error) {
      LCDLog(@"----- Fail to add new comment");
      [self enableCommentField:YES];
    }];
  }
}

#pragma mark - Private method implementation
- (void)initialUISetUp
{
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.nextPageLoaderCell = [LCUtilityManager getNextPageLoaderCell];
  UIView *zeroRectView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tableView.tableFooterView = zeroRectView;
  [settingsButton.layer setCornerRadius:5.0f];
}

- (void)refreshEventDetails
{
  [self dataPopulation];
  if ((self.eventObject.isFollowing || self.eventObject.isOwner)  && self.results.count ==0) {
    [self startFetchingResults];
  }
}

- (void)dataPopulation
{
  [settingsButton setTitle:NSLocalizedString(@"settings", @"settings Button Titile") forState:UIControlStateNormal];
  if (!self.eventObject.isOwner) {
    [self hideCommentsFields];
    if (self.eventObject.isFollowing) {
      [self showCommentsField];
    }
    [settingsButton setTitle:self.eventObject.isFollowing ? NSLocalizedString(@"attending", @"Attending button title") : NSLocalizedString(@"attend", @"attend button title") forState:UIControlStateNormal];
  } else {
    [self showCommentsField];
  }

  [eventNameLabel setText:self.eventObject.name];
  [eventPhoto sd_setImageWithURL:[NSURL URLWithString:self.eventObject.headerPhoto] placeholderImage:nil];
  
  // -------- Created By 'Owner' in 'Interest' -------- //
  NSString * eventCreatedBy = NSLocalizedString(@"event_created_by", nil);
  NSString  *eventOwnerName;
  NSString * inText = NSLocalizedString(@"in_", nil);
  NSString * interest = [LCUtilityManager performNullCheckAndSetValue:self.eventObject.interestName];
  if ([self.eventObject.userID isEqualToString:[LCDataManager sharedDataManager].userID]) {
    eventOwnerName = NSLocalizedString(@"you_", nil);
  }
  else
  {
    eventOwnerName = [NSString stringWithFormat:@"%@ %@ ",
                      [LCUtilityManager performNullCheckAndSetValue:self.eventObject.ownerFirstName],
                      [LCUtilityManager performNullCheckAndSetValue:self.eventObject.ownerLastName]];
  }
  
  NSString * eventinfoString = [NSString stringWithFormat:@"%@%@%@%@",eventCreatedBy,eventOwnerName,inText,interest];
  NSMutableAttributedString * eventInfoAttribString = [[NSMutableAttributedString alloc] initWithString:eventinfoString];
  
  
  NSRange tagRangeCreatedBy = [eventinfoString rangeOfString:eventCreatedBy];
  [eventInfoAttribString addAttributes:@{
                                         NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:14],
                                         NSForegroundColorAttributeName : [UIColor whiteColor]
                                         } range:tagRangeCreatedBy];
  
  NSRange tagRangeUserName = [eventinfoString rangeOfString:eventOwnerName];
  [eventInfoAttribString addAttributes:@{
                                             NSFontAttributeName : [UIFont fontWithName:@"Gotham-Medium" size:14],
                                             NSForegroundColorAttributeName : [UIColor colorWithRed:239/255.0f green:100/255.0f blue:77/255.0f alpha:1]
                                             } range:tagRangeUserName];
  
  
  NSRange tagRangeinText = [eventinfoString rangeOfString:inText];
  [eventInfoAttribString addAttributes:@{
                                         NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:14],
                                         NSForegroundColorAttributeName : [UIColor whiteColor]
                                         } range:tagRangeinText];


  NSRange tagRangeinterest = [eventinfoString rangeOfString:interest];
  [eventInfoAttribString addAttributes:@{
                                         NSFontAttributeName : [UIFont fontWithName:@"Gotham-Medium" size:14],
                                         NSForegroundColorAttributeName : [UIColor colorWithRed:107/255.0f green:215/255.0f blue:243/255.0f alpha:1]
                                         } range:tagRangeinterest];
  
  NSMutableArray *tagsWithRanges = [[NSMutableArray alloc] init];
  // -- User Info Tag -- //
  NSDictionary *dic_user = [[NSDictionary alloc] initWithObjectsAndKeys:self.eventObject.userID, kIDKey,kFeedTagTypeUser, kWordType, [NSValue valueWithRange:tagRangeUserName], kRange, nil];
  [tagsWithRanges addObject:dic_user];
  // -- Interest Info Tag -- //
  NSDictionary *dic_interest = [[NSDictionary alloc] initWithObjectsAndKeys:self.eventObject.interestID, kIDKey, kFeedTagTypeInterest, kWordType, [NSValue valueWithRange:tagRangeinterest], kRange, nil];
  [tagsWithRanges addObject:dic_interest];
  
  eventCreatedByLabel.tagsArray  = tagsWithRanges;
  [eventCreatedByLabel setAttributedText:eventInfoAttribString];
  __weak typeof(self) weakSelf = self;
  eventCreatedByLabel.nameTagTapped = ^(int index) {
    [weakSelf tagTapped:eventCreatedByLabel.tagsArray[index]];
  };
  
  if (![LCUtilityManager isEmptyString:self.eventObject.startDate]) {
    NSString * eventDateInfo = [LCUtilityManager getDateFromTimeStamp:self.eventObject.startDate WithFormat:@"MMM dd yyyy"];
    if (![LCUtilityManager isEmptyString:self.eventObject.endDate]) {
      eventDateInfo = [NSString stringWithFormat:@"%@ to %@",eventDateInfo,[LCUtilityManager getDateFromTimeStamp:self.eventObject.endDate WithFormat:@"MMM dd yyyy"]];
    }
    [eventdateInfoLable setText:eventDateInfo];
  }
  
  [self.tableView reloadData];
}

- (UIView*)getHeaderViewWithHeaderTitle:(NSString*)title
{
  LCActionsHeader * headerView = [[[NSBundle mainBundle] loadNibNamed:@"LCActionsHeader" owner:self options:nil] firstObject];
  [headerView.headerTextLabel setText:title];
  return headerView;
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [self initialUISetUp];
  [self getEventDetails];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:NO];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

#pragma mark - button actions
- (IBAction)backAction:(id)sender
{
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:NO MenuHiddenStatus:NO];
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingsAction:(id)sender
{
  if (self.eventObject.isOwner) {
    LCActionsForm *createController = [LCActionsFormPresenter getEditActionsControllerWithEvent:self.eventObject];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:createController];
    [self presentViewController:naviController animated:YES completion:nil];
    return;
  }
  
  [settingsButton setUserInteractionEnabled:NO];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  if (self.eventObject.isFollowing) {
    [settingsButton setTitle:NSLocalizedString(@"attend", @"attend button title") forState:UIControlStateNormal];
    [LCAPIManager unfollowEvent:self.eventObject withSuccess:^(id response) {
      [settingsButton setUserInteractionEnabled:YES];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    } andFailure:^(NSString *error) {
      [settingsButton setTitle:NSLocalizedString(@"attending", @"Attending button title") forState:UIControlStateNormal];
      [settingsButton setUserInteractionEnabled:YES];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
  } else {
    [settingsButton setTitle:NSLocalizedString(@"attending", @"Attending button title") forState:UIControlStateNormal];
    [LCAPIManager followEvent:self.eventObject withSuccess:^(id response) {
      [settingsButton setUserInteractionEnabled:YES];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
      if ((self.eventObject.isFollowing || self.eventObject.isOwner)  && self.results.count ==0) {
        [self startFetchingResults];
      }
    } andFailure:^(NSString *error) {
      [settingsButton setTitle:NSLocalizedString(@"attend", @"attend button title") forState:UIControlStateNormal];
      [settingsButton setUserInteractionEnabled:YES];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
  }
}

- (void)membersAction
{
  LCDLog(@"members clicked-->>");
}

- (void)websiteLinkAction
{
  if (self.eventObject.website) {
    NSURL * websiteURL = [NSURL HTTPURLFromString:self.eventObject.website];
    if ([[UIApplication sharedApplication] canOpenURL:websiteURL]) {
      [[UIApplication sharedApplication] openURL:websiteURL];
    }
  }
}

- (void)gotoMembersScreen
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kCommunityStoryBoardIdentifier bundle:nil];
  LCEventMembersViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LCEventMembersViewController"];
  vc.event = self.eventObject;
  [self.navigationController pushViewController:vc animated:YES];
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
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0)
  {
    if ([LCUtilityManager isaValidWebsiteLink:self.eventObject.website]) {
      return 3;
    }
    return 2;
  }
  if (self.eventObject.isFollowing) {
    return [super tableView:tableView numberOfRowsInSection:section];
  }
  return 1;//Cell for 'Follow the event to view and post comments' message.
  
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return kActionSectionHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  NSString * headerText;
  switch (section)
  {
    case 0:
      headerText = NSLocalizedString(@"details_caps", nil);
      break;
      
    default:
      headerText = NSLocalizedString(@"comments_caps", nil);
      break;
  }
  return [self getHeaderViewWithHeaderTitle:headerText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0)
  {
    switch (indexPath.row)
    {
      case 0:
        return [self getActionsDetailsCell];
        break;
        
      case 1:
        return [self getActionsMembersCountCell];
        break;
        
      default:
        return [self getActionsWebsiteCell];
        break;
    }
  }
  
  if (!self.eventObject.isFollowing) {
    UITableViewCell * followEventCell = [LCUtilityManager getEmptyIndicationCellWithText:NSLocalizedString(@"follow_event_message", @"Follow the event to view and post comments")];
    [followEventCell setBackgroundColor:[UIColor clearColor]];
    return followEventCell;
  }
  
  JTTABLEVIEW_cellForRowAtIndexPath
  LCCommentCell *commentCell;
  static NSString *MyIdentifier = @"LCCommentCell";
  commentCell = (LCCommentCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (commentCell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCCommentCellXIB" owner:self options:nil];
    commentCell = [topLevelObjects objectAtIndex:0];
  }
  [commentCell setComment:[self.results objectAtIndex:indexPath.row]];
  [commentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
  __weak typeof(self) weakSelf = self;
  commentCell.commentCellTagAction = ^ (NSDictionary * tagDetails) {
    [weakSelf tagTapped:tagDetails];
  };
  [commentCell.seperator setHidden:self.results.count -1 == indexPath.row];
  return commentCell;
}


- (LCActionsDetailsCell*)getActionsDetailsCell
{
  static NSString *MyIdentifier = @"LCActionsDetailsCell";
  LCActionsDetailsCell * cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCActionsDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
  }
  cell.communityDetailsLabel.text = [LCUtilityManager performNullCheckAndSetValue:self.eventObject.eventDescription];
  return cell;
}

- (LCActionsMembersCountCell*)getActionsMembersCountCell
{
  static NSString *MyIdentifier = @"LCActionsMembersCountCell";
  LCActionsMembersCountCell * cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCActionsMembersCountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
  }
  if (self.eventObject.followerCount) {
    NSString *membersText = @"Member";
    if ([self.eventObject.followerCount integerValue]>1) {
      membersText = @"Members";
    }
    cell.communityMemebersCountLabel.text = [NSString stringWithFormat:@"%@ %@",self.eventObject.followerCount, membersText];
  }
  [cell.seperator setHidden:self.eventObject.website ? NO : YES];
  return cell;
}

- (LCActionsWebsiteCell*)getActionsWebsiteCell
{
  static NSString *MyIdentifier = @"LCActionsWebsiteCell";
  LCActionsWebsiteCell * cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCActionsWebsiteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
  }
  cell.communityWebsiteLabel.text = self.eventObject.website;
  return cell;
}

#pragma mark - UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if (indexPath.section == 0) {
    switch (indexPath.row) {
        
      case 1:
        [self gotoMembersScreen];
        break;

      case 2:
        [self websiteLinkAction];
        break;
        
      default:
        break;
    }
  }
}

@end
