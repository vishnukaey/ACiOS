//
//  LCOnboardFinalSelectionVC.m
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardFinalSelectionVC.h"
#import "LCCausesCollectionTableViewCell.h"
#import "LCOnboardCausesVC.h"
#import "LCOnboardingHelper.h"
#import "LCContactsListVC.h"

#pragma mark - LCCausesHeaderReusableView class
@interface LCCausesHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *interestName;
@property (weak, nonatomic) IBOutlet UIButton *showAllButton;
@end

@implementation LCCausesHeaderTableViewCell
@end

@interface LCOnboardFinalSelectionVC ()

@end

NSString *const kCellIdSectionHeader = @"headerCell";
NSString *const kCellIdSectionFooter = @"footerCell";
NSString *const kCellIdTableViewCell = @"causesTableViewCell";
NSInteger const kTableCellHeight = 170;
NSInteger const kTableHeaderHeight = 44;
NSInteger const kNoOfRowsInSection = 1;

@implementation LCOnboardFinalSelectionVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  [self getCausesSuggestions];
  [self updateDoneButton];
}

- (void) viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void) getCausesSuggestions {
  
  NSArray *selectedInterests = [[LCOnboardingHelper selectedItemsDictionary] allKeys];
  
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [LCThemeAPIManager getCausesForSetOfInterests:selectedInterests withSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    self.interestArray = response;
    [self.tableView reloadData];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
  }];
}

#pragma mark - Actoin Methods

- (IBAction)showAllAction:(UIButton*)sender {
  
  NSInteger section = sender.tag;
  LCInterest *interest = self.interestArray[section];
  
  UIStoryboard *  signupSB = [UIStoryboard  storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
  LCOnboardCausesVC *causeVC = [signupSB instantiateViewControllerWithIdentifier:@"LCOnboardCausesVC"];
  causeVC.interest = interest;
  [self.navigationController pushViewController:causeVC animated:YES];;
}

- (IBAction)nextButtonAction:(id)sender {
  
  NSDictionary *selectedItems = [LCOnboardingHelper selectedItemsDictionary];
  NSArray *interestsToSave = [selectedItems allKeys];
  NSArray *allInterests = [selectedItems allValues];
  NSMutableArray *causesToSave = [[NSMutableArray alloc] init];
  for(LCInterest *interest in allInterests) {
    for (LCCause *cause in interest.causes) {
      [causesToSave addObject:cause.causeID];
    }
  }
  
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [LCThemeAPIManager saveCauses:causesToSave
                   andInterests:interestsToSave
                         ofUser:[LCDataManager sharedDataManager].userID
                    withSuccess:^(id response) {
                      [[LCOnboardingHelper selectedItemsDictionary] removeAllObjects];
                      [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
                      UIStoryboard *storyboard = [UIStoryboard  storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
                      LCContactsListVC *next = [storyboard instantiateViewControllerWithIdentifier:@"connectFriends"];
                      [self.navigationController pushViewController:next animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
  }];
}


-(IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.interestArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return kNoOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kTableCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  return kTableHeaderHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  NSString *cellIdentifier = kCellIdSectionHeader;
  LCCausesHeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  LCInterest *interest = self.interestArray[section];
  headerView.interestName.text = interest.name;
  headerView.showAllButton.tag = section;
  return  headerView ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellIdentifier = kCellIdTableViewCell;
  LCCausesCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  cell.interest = (LCInterest*)self.interestArray[indexPath.section];
  [cell reloadCollectionView];
  [self updateDoneButton];
  return cell;
}

- (void)updateDoneButton
{
  [_doneBUtton setEnabled:![LCOnboardingHelper noInterestSelected]];
}


@end
