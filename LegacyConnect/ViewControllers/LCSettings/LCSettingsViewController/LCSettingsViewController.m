//
//  LCSettingsViewControllerTableViewController.m
//  LegacyConnect
//
//  Created by qbuser on 10/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSettingsViewController.h"
#import "LCUpdateEmailViewController.h"
#import "LCChangePasswordViewController.h"
#import "LCPrivacyViewController.h"
#import "LCMyLegacyURLViewController.h"

#define kIndexSectionAccount 0
#define kIndexSectionSignOut 1
#define kStoryVoardId @"LCSettingsVC"
#define kSettingsCellIdentifier @"LCSettingsCell"
#define kSettingsSignOutCellIdentifier @"LCSettingsSignOutCell"
#define kSettingsHeaderCellIdentifier @"LCSettingsHeaderCell"

#define kTextLeft @"left_text"
#define kTextRight @"right_text"

static CGFloat kNumberOfSection =2;

@interface LCSettingsViewController ()

@property (nonatomic, strong) NSArray *accountDataSource;
@property (nonatomic, strong) NSArray *signOutDataSource;

@end

@implementation LCSettingsViewController

#pragma mark - private method implementation

+ (NSString*)getStoryBoardIdentifier
{
  return kStoryVoardId;
}

#pragma mark - private method implementation

- (void)doneButtonPressed:(id)sender
{
  
}

- (void)initialUISetUp
{
  //self.clearsSelectionOnViewWillAppear = NO;
  _settingsTableView.dataSource = self;
  _settingsTableView.delegate = self;
  // self.navigationController.navigationBarHidden = false;
  //self.title = kSettingsScreenTitle;
  
}

- (void)prepareDataSource {
  
  NSString * userEmail = [LCUtilityManager performNullCheckAndSetValue:[LCDataManager sharedDataManager].userEmail];
  NSString * firstName = [LCUtilityManager performNullCheckAndSetValue:[LCDataManager sharedDataManager].firstName];
  NSString * lastName = [LCUtilityManager performNullCheckAndSetValue:[LCDataManager sharedDataManager].lastName];
  
  self.accountDataSource = @[ @{kTextLeft : kEmailAddress, kTextRight : userEmail},
                              @{kTextLeft : kChangePassword, kTextRight : kEmptyStringValue},
                              @{kTextLeft : kMyLegacyURL, kTextRight : [NSString stringWithFormat:@"%@ %@",firstName, lastName]},
                              @{kTextLeft : kPrivacy, kTextRight : kEmptyStringValue} ];
  
  self.signOutDataSource = @[ @{kTextLeft : kSignOut, kTextRight : kEmptyStringValue} ];
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
  [self prepareDataSource];
  [_settingsTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
//  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:NO];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return kNumberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section)
  {
    case kIndexSectionAccount:
      return self.accountDataSource.count;
      break;
      
    default:
      return 1;
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  UITableViewCell *cell = nil;
  
  if (indexPath.section == kIndexSectionAccount) {
    
    cell = [tableView dequeueReusableCellWithIdentifier:kSettingsCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSettingsCellIdentifier];
    }
    [cell.textLabel setText:[(NSDictionary*)[_accountDataSource objectAtIndex:indexPath.row] objectForKey:kTextLeft]];
    [cell.detailTextLabel setText:[(NSDictionary*)[_accountDataSource objectAtIndex:indexPath.row] objectForKey:kTextRight]];
  }
  else if (indexPath.section == kIndexSectionSignOut) {
    
    cell = [tableView dequeueReusableCellWithIdentifier:kSettingsSignOutCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSettingsSignOutCellIdentifier];
    }
  }
  
  
  //  if (cell == nil) {
  //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSettingsCellIdentifier];
  //  }
  //
  //  NSArray * currentDataSource = nil;
  //
  //  switch (indexPath.section)
  //  {
  //    case kIndexSectionAccount:
  //      currentDataSource = self.accountDataSource;
  //      break;
  //
  //    case kIndexSectionSignOut:
  //      currentDataSource = self.signOutDataSource;
  //      break;
  //
  //    default:
  //      break;
  //  }
  //
  //  [cell.textLabel setText:[(NSDictionary*)[currentDataSource objectAtIndex:indexPath.row] objectForKey:kTextLeft]];
  //  [cell.detailTextLabel setText:[(NSDictionary*)[currentDataSource objectAtIndex:indexPath.row] objectForKey:kTextRight]];
  //
  //  if (indexPath.section == kIndexSectionSignOut)
  //  {
  //    cell.accessoryType = UITableViewCellAccessoryNone;
  //  }
  //
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  NSString *cellIdentifier = kSettingsHeaderCellIdentifier;
  UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (headerView == nil) {
    headerView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
  }
  
  UILabel *sectionLabel = (UILabel *)[headerView viewWithTag:100];
  switch (section)
  {
    case kIndexSectionAccount:
      sectionLabel.text = kAccountTitle;
      break;
      
    default:
      sectionLabel.text = kEmptyStringValue;
      break;
  }
  
  return  headerView ;
}


#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSLog(@"indexpath section : %ld and row : %ld",indexPath.section,indexPath.row);
  if (indexPath.section == kIndexSectionAccount) {
    switch (indexPath.row) {
      case 0:
        [self showUpdateEmailScreen];
        break;
        
      case 1:
        [self showChangePasswordScreen];
        break;
        
      case 2:
        [self showLegacyURLScreen];
        break;
        
      case 3:
        [self showPrivacyScreen];
        break;
        
      default:
        break;
    }
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showUpdateEmailScreen
{
  LCUpdateEmailViewController * updateMailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCUpdateEmailVC"];
  updateMailVC.emailAddress = [LCDataManager sharedDataManager].userEmail;
  //[self.navigationController pushViewController:updateMailVC animated:YES];
  [self presentViewController:updateMailVC animated:YES completion:nil];
}

- (void)showChangePasswordScreen
{
  LCChangePasswordViewController * passwordVc = [self.storyboard instantiateViewControllerWithIdentifier:@"LCChangePasswordVC"];
  [self presentViewController:passwordVc animated:YES completion:nil];
}

- (void)showLegacyURLScreen
{
  LCMyLegacyURLViewController * legacyURLVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCMyLegacyURLVC"];
  [self.navigationController pushViewController:legacyURLVC animated:YES];
}

- (void)showPrivacyScreen
{
  LCPrivacyViewController * privacyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCPrivacyVC"];
  [self.navigationController pushViewController:privacyVC animated:YES];
}


@end
