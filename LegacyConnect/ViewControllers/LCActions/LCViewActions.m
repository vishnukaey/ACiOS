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
#import "NSURL+LCURLCategory.h"
#import "LCEventAPImanager.h"
#import "LCReportHelper.h"
#import "LCActionHelper.h"

static CGFloat kActionSectionHeight = 30;

#define kActionsHeaderBG [UIColor colorWithRed:235/255.0 green:236/255.0 blue:237/255.0 alpha:1]
#define kActionsHeaderText [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1]
#define kActionsHeaderTextFont [UIFont fontWithName:@"Gotham-Medium" size:11]

#pragma mark - LCCommunityDetailCell class
@interface LCActionsDetailsCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *communityDetailsLabel;
@end

@implementation LCActionsDetailsCell
- (void)awakeFromNib
{
  self.communityDetailsLabel.numberOfLines = 0;
}

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
  [LCEventAPImanager getCommentsForEvent:self.eventObject.eventID lastCommentID:nil withSuccess:^(id response, BOOL isMore) {
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
  [LCEventAPImanager getCommentsForEvent:self.eventObject.eventID lastCommentID:[(LCComment*)[self.results lastObject] commentId] withSuccess:^(id response, BOOL isMore) {
    [self didFetchNextResults:response haveMoreData:isMore];
  } andfailure:^(NSString *error) {
    [self didFailedToFetchResults];
  }];
}

#pragma mark - Event Details API call
-(void)getEventDetails
{
  [LCEventAPImanager getEventDetailsForEventWithID:self.eventObject.eventID withSuccess:^(LCEvent *responses) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.eventObject = responses;
    [self dataPopulation];
    if ((self.eventObject.isFollowing || self.eventObject.isOwner)  && self.results.count ==0) {
      [self startFetchingResults];
    }
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView setHidden:YES];
    eventCreatedByLabel.hidden = YES;
    eventdateInfoLable.hidden = YES;
    eventNameLabel.hidden = YES;
    eventPhoto.hidden = YES;
    settingsButton.hidden = YES;
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
    [LCEventAPImanager postCommentToEvent:self.eventObject comment:commentTextField.text withSuccess:^(id response) {
      [commentTextField setText:nil];
      [commentTextField_dup setText:nil];
      [self changeUpdateButtonState];
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
  self.tableView.estimatedRowHeight = 120.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.nextPageLoaderCell = [LCPaginationHelper getNextPageLoaderCell];
  UIView *zeroRectView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tableView.tableFooterView = zeroRectView;
  [settingsButton.layer setCornerRadius:5.0f];
  [blockActionBtn setHidden:YES];
  [blockActionBtnImg setHidden:YES];
}

- (void)refreshEventDetails
{
  [self dataPopulation];
  if ((self.eventObject.isFollowing || self.eventObject.isOwner)  && self.needCommentRefresh) {
    [self startFetchingResults];
  }
}

- (void)updateEventTitleAndTopUI
{
  [settingsButton setTitle:NSLocalizedString(@"settings", @"settings Button Titile") forState:UIControlStateNormal];
  if (!self.eventObject.isOwner) {
    [self hideCommentsFields];
    if (self.eventObject.isFollowing) {
      [self showCommentsField];
    }
    [settingsButton setTitle:self.eventObject.isFollowing ? NSLocalizedString(@"supporting", @"Attending button title") : NSLocalizedString(@"support", @"attend button title") forState:UIControlStateNormal];
  } else {
    [self showCommentsField];
  }
  
  [eventNameLabel setText:self.eventObject.name];
  [eventPhoto sd_setImageWithURL:[NSURL URLWithString:self.eventObject.headerPhoto] placeholderImage:nil];

}
- (void)dataPopulation
{
  [self updateEventTitleAndTopUI];
  [self setEventDetailsInfo];
  [eventdateInfoLable setText:[LCActionHelper getEventDateInfo:self.eventObject]];
  [self blockEventUI];
  [self.tableView reloadData];
}

- (void)setEventDetailsInfo
{
  NSString * eventCreatedBy = NSLocalizedString(@"event_created_by", nil);
  NSString  *eventOwnerName;
  NSString * inText = NSLocalizedString(@"in_", nil);
  NSString * interest = [LCUtilityManager performNullCheckAndSetValue:self.eventObject.interestName];
  
  eventOwnerName = NSLocalizedString(@"you_", nil);
  
  
  if (![self.eventObject.userID isEqualToString:[LCDataManager sharedDataManager].userID]) {
    eventOwnerName = [NSString stringWithFormat:@"%@ %@ ",
                      [LCUtilityManager performNullCheckAndSetValue:self.eventObject.ownerFirstName],
                      [LCUtilityManager performNullCheckAndSetValue:self.eventObject.ownerLastName]];
  }
  
  NSString * eventinfoString = [NSString stringWithFormat:@"%@%@ %@%@",eventCreatedBy,eventOwnerName,inText,interest];
  NSMutableAttributedString * eventInfoAtribString = [[NSMutableAttributedString alloc] initWithString:eventinfoString];
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
  [paragraphStyle setAlignment:NSTextAlignmentCenter];
  
  [eventInfoAtribString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [eventInfoAtribString length])];
  
  NSRange tagRangeCreatedBy = [eventinfoString rangeOfString:eventCreatedBy];
  [eventInfoAtribString addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:14], NSForegroundColorAttributeName : [UIColor whiteColor]} range:tagRangeCreatedBy];
  
  NSRange tagRangeUserName = [eventinfoString rangeOfString:eventOwnerName];
  [eventInfoAtribString addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Medium" size:14], NSForegroundColorAttributeName : [LCUtilityManager getThemeRedColor]} range:tagRangeUserName];
  
  NSRange tagRangeinText = [eventinfoString rangeOfString:inText];
  [eventInfoAtribString addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:14], NSForegroundColorAttributeName : [UIColor whiteColor]} range:tagRangeinText];
  
  NSRange tagRangeinterest = [eventinfoString rangeOfString:interest];
  [eventInfoAtribString addAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Gotham-Medium" size:14], NSForegroundColorAttributeName : [UIColor colorWithRed:107/255.0f green:215/255.0f blue:243/255.0f alpha:1]} range:tagRangeinterest];
  
  [self setTaggedLabelWithTagRangeUsername:tagRangeUserName andTagRangeinterest:tagRangeinterest eventOwnerName:eventOwnerName andInfoString:eventInfoAtribString];
  
}

- (void)setTaggedLabelWithTagRangeUsername:(NSRange)tagRangeUserName andTagRangeinterest:(NSRange)tagRangeinterest
                            eventOwnerName:(NSString*)eventOwnerName andInfoString:(NSMutableAttributedString*)infoString
{
  NSMutableArray *tagsWithRanges = [[NSMutableArray alloc] init];
  
  // -- Interest Info Tag -- //
  NSDictionary *dic_interest = [[NSDictionary alloc] initWithObjectsAndKeys:self.eventObject.interestID, kTagobjId, kFeedTagTypeInterest, kTagobjType, [NSValue valueWithRange:tagRangeinterest], kRange, nil];
  [tagsWithRanges addObject:dic_interest];
  
  // -- User Info Tag -- //
  NSDictionary *dic_user = [[NSDictionary alloc] initWithObjectsAndKeys:self.eventObject.userID, kIDKey,kFeedTagTypeUser, kTagobjType, [NSValue valueWithRange:tagRangeUserName], kRange, eventOwnerName, kTagobjText, nil];
  [tagsWithRanges addObject:dic_user];
  
  
  eventCreatedByLabel.tagsArray  = tagsWithRanges;
  [eventCreatedByLabel setAttributedText:infoString];
  __weak typeof(self) weakSelf = self;
  eventCreatedByLabel.nameTagTapped = ^(int index) {
    [weakSelf tagTapped:eventCreatedByLabel.tagsArray[index]];
  };
}

- (void)blockEventUI
{
  if (self.eventObject.userID) {
    if ([self.eventObject.userID isEqualToString:[LCDataManager sharedDataManager].userID]) {
      [blockActionBtn setHidden:YES];
      [blockActionBtnImg setHidden:YES];
    } else {
      [blockActionBtn setHidden:NO];
      [blockActionBtnImg setHidden:NO];
    }
  }
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
    [naviController.interactivePopGestureRecognizer setDelegate:nil];
    [self presentViewController:naviController animated:YES completion:nil];
    return;
  }
  
  [settingsButton setUserInteractionEnabled:NO];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  if (self.eventObject.isFollowing) {
    [settingsButton setTitle:NSLocalizedString(@"support", @"attend button title") forState:UIControlStateNormal];
    [LCEventAPImanager unfollowEvent:self.eventObject withSuccess:^(id response) {
      [settingsButton setUserInteractionEnabled:YES];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    } andFailure:^(NSString *error) {
      [settingsButton setTitle:NSLocalizedString(@"supporting", @"Attending button title") forState:UIControlStateNormal];
      [settingsButton setUserInteractionEnabled:YES];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
  } else {
    [settingsButton setTitle:NSLocalizedString(@"supporting", @"Attending button title") forState:UIControlStateNormal];
    [LCEventAPImanager followEvent:self.eventObject withSuccess:^(id response) {
      [settingsButton setUserInteractionEnabled:YES];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
      if ((self.eventObject.isFollowing || self.eventObject.isOwner)  && self.results.count ==0) {
        [self startFetchingResults];
      }
    } andFailure:^(NSString *error) {
      [settingsButton setTitle:NSLocalizedString(@"support", @"attend button title") forState:UIControlStateNormal];
      [settingsButton setUserInteractionEnabled:YES];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
  }
}

- (void)websiteLinkAction
{
  if (self.eventObject.website) {
    NSURL * websiteURL = [NSURL HTTPURLFromString:self.eventObject.website];
    if ([[UIApplication sharedApplication] canOpenURL:websiteURL])
    {
      [[UIApplication sharedApplication] openURL:websiteURL];
    }
  }
}

- (void)gotoMembersScreen
{
  UIStoryboard*  actionsSB = [UIStoryboard storyboardWithName:kCommunityStoryBoardIdentifier bundle:nil];
  LCEventMembersViewController *membersVC = [actionsSB instantiateViewControllerWithIdentifier:@"LCEventMembersViewController"];
  membersVC.event = self.eventObject;
  [self.navigationController pushViewController:membersVC animated:YES];
}

- (IBAction)blockActionBtnTapped:(id)sender {
  [LCReportHelper showActionReportActionSheetFromView:self withAction:self.eventObject];
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
  return [LCActionHelper getActionsHeaderForSection:section];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0)
  {
    if (indexPath.row == 0) {
      return [self getActionsDetailsCell];
    } else if (indexPath.row == 1) {
      return [self getActionsMembersCountCell];
    }
    return [self getActionsWebsiteCell];
  }
  
  if (!self.eventObject.isFollowing) {
    UITableViewCell * followEventCell = [LCPaginationHelper getEmptyIndicationCellWithText:NSLocalizedString(@"follow_event_message", @"Follow the event to view and post comments")];
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
    commentCell = topLevelObjects[0];
  }
  [commentCell setComment:[self.results objectAtIndex:indexPath.row]];
  [commentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
  __weak typeof(self) weakSelf = self;
  commentCell.commentCellTagAction = ^ (NSDictionary * tagDetails) {
    [weakSelf tagTapped:tagDetails];
  };
  commentCell.commentCellMoreAction =^(){
    [LCReportHelper showCommentReportActionSheetFromView:self forAction:self.eventObject withComment:self.results[indexPath.row] isMyAction:self.eventObject.isOwner];
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
  
  [cell.communityDetailsLabel setNumberOfLines:0];
  [cell.communityDetailsLabel sizeToFit];

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
  [cell.seperator setHidden:!self.eventObject.website];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.tableView.rowHeight;
  }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if (indexPath.section == 0) {
    
    if (indexPath.row == 1) {
      [self gotoMembersScreen];
    } else if (indexPath.row == 2) {
      [self websiteLinkAction];
    }
  }
}

@end
