//
//  LCSettingsViewControllerTableViewController.m
//  LegacyConnect
//
//  Created by qbuser on 10/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSettingsViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define kIndexSectionAccount 0
#define kIndexSectionSignOut 1
#define kStoryVoardId @"LCSettingsVC"
#define kSettingsCellIdentifier @"LCSettingsCell"
#define kSettingsSignOutCellIdentifier @"LCSettingsSignOutCell"
#define kSettingsHeaderCellIdentifier @"LCSettingsHeaderCell"

#define kTextLeft @"left_text"
#define kTextRight @"right_text"

static CGFloat kNumberOfSection = 2;

@interface LCSettingsViewController ()

@property (nonatomic, strong) NSArray *accountDataSource;
@property (nonatomic, strong) NSArray *signOutDataSource;

@end

@implementation LCSettingsViewController

#pragma mark - view life cycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialSetUp];
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:NO];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - private method implementation

- (void)doneButtonPressed:(id)sender
{
  
}

- (void)initialSetUp
{
  [MBProgressHUD showHUDAddedTo:settingsTableView animated:YES];
  [LCAPIManager getSettignsOfUserWithSuccess:^(LCSettings *responses) {
    [MBProgressHUD hideAllHUDsForView:settingsTableView animated:YES];
    _settingsData = responses;
    [self prepareDataSource];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:settingsTableView animated:YES];
    LCDLog(@"error - %@", error);
    [self prepareDataSource];
    [settingsTableView setAllowsSelection:NO];
  }];
  
}

- (void)prepareDataSource {
  
  self.accountDataSource = @[ @{kTextLeft : kEmailAddress,
                                kTextRight : [LCUtilityManager performNullCheckAndSetValue:_settingsData.email]},
                              @{kTextLeft : kChangePassword,
                                kTextRight : kEmptyStringValue},
                              @{kTextLeft : kMyLegacyURL,
                                kTextRight : [LCUtilityManager performNullCheckAndSetValue:_settingsData.legacyUrl]},
                              @{kTextLeft : kPrivacy,
                                kTextRight : [LCUtilityManager performNullCheckAndSetValue:_settingsData.privacy]}
                              ];
  
  self.signOutDataSource = @[ @{kTextLeft : kSignOut, kTextRight : kEmptyStringValue} ];
  [settingsTableView reloadData];
}

- (void)updateView {
  [self prepareDataSource];
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
  else {
    
    [self signOutLegacy];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showUpdateEmailScreen
{
  LCUpdateEmailViewController * updateMailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCUpdateEmailVC"];
  updateMailVC.settingsData = _settingsData;
  updateMailVC.delegate = self;
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
  legacyURLVC.settingsData = _settingsData;
  legacyURLVC.delegate = self;
  [self presentViewController:legacyURLVC animated:YES completion:nil];
}

- (void)showPrivacyScreen
{
  LCPrivacyViewController * privacyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCPrivacyVC"];
  privacyVC.settingsData = _settingsData;
  privacyVC.delegate = self;
  [self presentViewController:privacyVC animated:YES completion:nil];
}

- (void) signOutLegacy {
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCAPIManager signOutwithSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    //[LCUtilityManager clearUserDefaultsForCurrentUser];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    if ([FBSDKAccessToken currentAccessToken])
    {
      [[FBSDKLoginManager new] logOut];
    }
    LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier bundle:nil];
    UIViewController* myStoryBoardInitialViewController = [storyboard instantiateInitialViewController];
    appdel.window.rootViewController = myStoryBoardInitialViewController;
    [appdel.window makeKeyAndVisible];

  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  }];
   
}


@end
