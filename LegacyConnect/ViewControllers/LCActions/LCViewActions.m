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

static CGFloat kActionSectionHeight = 30;
static CGFloat kActionSectionTitleOffset = 10;

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
@end

@implementation LCActionsMembersCountCell
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
//  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
//  [super startFetchingResults];
//  [LCAPIManager getEventDetailsForEventWithID:self.eventObject.eventID withSuccess:^(NSArray *response) {
//    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
//    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
//    [self didFetchResults:response haveMoreData:hasMoreData];
//  } andFailure:^(NSString *error) {
//    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
//    [self didFailedToFetchResults];
//  }];
}

- (void)startFetchingNextResults
{
//  [super startFetchingNextResults];
//  
//  [LCAPIManager getEventDetailsForEventWithID:self.eventObject.eventID withSuccess:^(NSArray *response) {
//    BOOL hasMoreData = ([(NSArray*)response count] < 10) ? NO : YES;
//    [self didFetchNextResults:response haveMoreData:hasMoreData];
//  } andFailure:^(NSString *error) {
//    [self didFailedToFetchResults];
//  }];
}

#pragma mark - Event Details API call
-(void)getEventDetails
{
  [LCAPIManager getEventDetailsForEventWithID:self.eventObject.eventID withSuccess:^(id response){
    self.eventObject = response;
    [self.tableView reloadData];
  }andFailure:^(NSString *error){
    LCDLog(@"%@",error);
  }];
}

- (void)postAction
{
  
}

#pragma mark - Private method implementation
- (void)initialUISetUp
{
  self.tableView.estimatedRowHeight = 44.0;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.nextPageLoaderCell = [LCUtilityManager getNextPageLoaderCell];
  UIView *zeroRectView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tableView.tableFooterView = zeroRectView;
}

- (void)dataPopulation
{
  [eventNameLabel setText:self.eventObject.name];
  [eventPhoto sd_setImageWithURL:[NSURL URLWithString:self.eventObject.headerPhoto] placeholderImage:nil];
  [settingsButton.layer setCornerRadius:5.0f];
  
  // -------- Created By 'Owner' in 'Interest' -------- //
  NSString * eventCreatedBy = @"Event Created by ";
  NSString  *eventOwnerName;
  NSString * inText = @"in ";
  NSString * interest = @"Water";
  if ([self.eventObject.eventID isEqualToString:[LCDataManager sharedDataManager].userID]) {
    eventOwnerName = @"You ";
  }
  else
  {
    eventOwnerName = [NSString stringWithFormat:@"%@ %@ ",
                      [LCUtilityManager performNullCheckAndSetValue:@"YOU"],
                      [LCUtilityManager performNullCheckAndSetValue:@""]];
  }
  
  NSString * eventinfoString = [NSString stringWithFormat:@"%@%@%@%@",eventCreatedBy,eventOwnerName,inText,interest];
  NSMutableAttributedString * eventInfoAttribString = [[NSMutableAttributedString alloc] initWithString:eventinfoString];
  
  
  NSRange tagRangeCreatedBy = [eventinfoString rangeOfString:eventCreatedBy];
  [eventInfoAttribString addAttributes:@{
                                         NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:14],
                                         NSForegroundColorAttributeName : [UIColor colorWithRed:235/255.0f green:236/255.0f blue:237/255.0f alpha:1]
                                         } range:tagRangeCreatedBy];
  
  NSRange tagRangeUserName = [eventinfoString rangeOfString:eventOwnerName];
  [eventInfoAttribString addAttributes:@{
                                             NSFontAttributeName : [UIFont fontWithName:@"Gotham-Medium" size:14],
                                             NSForegroundColorAttributeName : [UIColor colorWithRed:239/255.0f green:100/255.0f blue:77/255.0f alpha:1]
                                             } range:tagRangeUserName];
  
  
  NSRange tagRangeinText = [eventinfoString rangeOfString:inText];
  [eventInfoAttribString addAttributes:@{
                                         NSFontAttributeName : [UIFont fontWithName:@"Gotham-Book" size:14],
                                         NSForegroundColorAttributeName : [UIColor colorWithRed:235/255.0f green:236/255.0f blue:237/255.0f alpha:1]
                                         } range:tagRangeinText];


  NSRange tagRangeinterest = [eventinfoString rangeOfString:interest];
  [eventInfoAttribString addAttributes:@{
                                         NSFontAttributeName : [UIFont fontWithName:@"Gotham-Medium" size:14],
                                         NSForegroundColorAttributeName : [UIColor colorWithRed:107/255.0f green:215/255.0f blue:243/255.0f alpha:1]
                                         } range:tagRangeinterest];
  
  NSMutableArray *tagsWithRanges = [[NSMutableArray alloc] init];
  // -- User Info Tag -- //
  NSDictionary *dic_user = [[NSDictionary alloc] initWithObjectsAndKeys:self.eventObject.eventID, kIDKey,kFeedTagTypeUser, kWordType, [NSValue valueWithRange:tagRangeUserName], kRange, nil];
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
}

- (UIView*)getHeaderViewWithHeaderTitle:(NSString*)title
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), kActionSectionHeight)];
  [view setBackgroundColor:kActionsHeaderBG];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kActionSectionTitleOffset, 0, CGRectGetWidth(self.tableView.frame) - kActionSectionTitleOffset, kActionSectionHeight)];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:kActionsHeaderText];
  [label setFont:kActionsHeaderTextFont];
  [label setText:title];
  [view addSubview:label];
  return view;
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  if ([tagDetails[kWordType] isEqualToString:kFeedTagTypeCause])
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
    [self.navigationController pushViewController:vc animated:YES];
  }
  else if ([tagDetails[kWordType] isEqualToString:kFeedTagTypeUser])
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    vc.userDetail = [[LCUserDetail alloc] init];
    vc.userDetail.userID = tagDetails[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
  [self dataPopulation];
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

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

#pragma mark - button actions
- (IBAction)backAction:(id)sender
{
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:NO MenuHiddenStatus:NO];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)settingsAction:(id)sender
{
  LCDLog(@"settings clicked-->>");
}

- (void)membersAction
{
  LCDLog(@"members clicked-->>");
}

- (void)websiteLinkAction
{
  LCDLog(@"website link clicked-->>");
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
    return 3;
  }
  return self.results.count;
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
  
  JTTABLEVIEW_cellForRowAtIndexPath
  LCCommentCell *commentCell;
  static NSString *MyIdentifier = @"LCCommentCell";
  commentCell = (LCCommentCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (commentCell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCCommentCellXIB" owner:self options:nil];
    commentCell = [topLevelObjects objectAtIndex:0];
  }
  NSInteger rowNo = indexPath.row - 1;
  [commentCell setComment:[self.results objectAtIndex:rowNo]];
  [commentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
  __weak typeof(self) weakSelf = self;
  commentCell.commentCellTagAction = ^ (NSDictionary * tagDetails) {
    [weakSelf tagTapped:tagDetails];
  };
  [commentCell.seperator setHidden:self.results.count == indexPath.row];
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
  NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[LCUtilityManager performNullCheckAndSetValue:self.eventObject.eventDescription]];
  cell.communityDetailsLabel.attributedText = attributedString;
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
//  cell.communityMemebersCountLabel.text = self.eventObject.supportersCount;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

@end
