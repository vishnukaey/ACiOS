//
//  LCChooseActionsInterest.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCChooseActionsInterest.h"
#import "LCActionsForm.h"
#import "LCActionsFormPresenter.h"
#import "LCCommunityInterestCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCInterestsCellView.h"


static NSString *kUnCheckedImageName = @"tagFirend_unselected";
static NSString *kCheckedImageName = @"contact_tick";


@implementation LCChooseActionsInterest
{
  LCInterest *selectedInterest;
  IBOutlet UIButton *nextButton;
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  nextButton.enabled = NO;
  
  if (!self.noResultsView) {
    
    NSString *message = NSLocalizedString(@"no_interests_available_self", nil);
    self.noResultsView = [LCUtilityManager getNoResultViewWithText:message andViewWidth:CGRectGetWidth(self.tableView.frame)];
  }
  [self startFetchingResults];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

#pragma mark - API call and Pagination

- (void)startFetchingResults
{
  [super startFetchingResults];
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [LCAPIManager getInterestsForUser:[LCDataManager sharedDataManager].userID withSuccess:^(NSArray *responses) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    BOOL hasMoreData = NO;
    [self didFetchResults:responses haveMoreData:hasMoreData];
    [self setNoResultViewHidden:[self.results count] != 0];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self didFailedToFetchResults];
    [self setNoResultViewHidden:[self.results count] != 0];
  }];
}

- (void)startFetchingNextResults
{
  //Currently no pagination required for interests
}

- (void)setNoResultViewHidden:(BOOL)hidded
{
  if (hidded) {
    [self hideNoResultsView];
  }
  else
  {
    [self showNoResultsView];
  }
}

#pragma mark - button actions
- (IBAction)cancelAction
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextAction
{
  LCActionsForm *createController = [LCActionsFormPresenter getCreateActionsControllerWithInterest:selectedInterest];
  [self.navigationController pushViewController:createController animated:YES];
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  JTTABLEVIEW_cellForRowAtIndexPath
  static NSString *MyIdentifier = @"LCInterestsCell";
  LCInterestsCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCInterestsCellView" owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
  }
  
  LCInterest *interstObj = [self.results objectAtIndex:indexPath.row];
  [cell setData:interstObj];
  tableView.backgroundColor = [tableView.superview backgroundColor];
  tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  tableView.allowsSelection = YES;
  
  cell.checkButton.hidden = NO;
  cell.checkButton.userInteractionEnabled = NO;
  if ([interstObj.interestID isEqualToString:selectedInterest.interestID])
  {
    [cell.checkButton setImage:[UIImage imageNamed:kCheckedImageName] forState:UIControlStateNormal];
  }
  else
  {
    [cell.checkButton setImage:[UIImage imageNamed:kUnCheckedImageName] forState:UIControlStateNormal];
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  selectedInterest = [self.results objectAtIndex:indexPath.row];
  [self.tableView reloadData];
  nextButton.enabled = YES;
}


@end
