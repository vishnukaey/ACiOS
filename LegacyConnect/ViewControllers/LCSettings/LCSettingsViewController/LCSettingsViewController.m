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
#define kIndexSectionBlock 1
#define kIndexSectionSignOut 2
#define kStoryVoardId @"LCSettingsVC"
#define kSettingsCellIdentifier @"LCSettingsCell"
#define kSettingsSignOutCellIdentifier @"LCSettingsSignOutCell"
#define kSettingsHeaderCellIdentifier @"LCSettingsHeaderCell"

#define kTextLeft @"left_text"
#define kTextRight @"right_text"

static CGFloat kNumberOfSection = 3;

@interface LCSettingsViewController ()

@property (nonatomic, strong) NSArray *accountDataSource;
@property (nonatomic, strong) NSArray *signOutDataSource;

@end

@implementation LCSettingsViewController

#pragma mark - view life cycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self prepareDataSource];
  [self getSettingsOfUser];
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

- (void)getSettingsOfUser
{
  [MBProgressHUD showHUDAddedTo:settingsTableView animated:YES];
  [LCSettingsAPIManager getSettignsOfUserWithSuccess:^(LCSettings *responses) {
    [MBProgressHUD hideAllHUDsForView:settingsTableView animated:YES];
    _settingsData = responses;
    [self prepareDataSource];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:settingsTableView animated:YES];
    LCDLog(@"error - %@", error);
    
//    [settingsTableView setAllowsSelection:NO];
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
  NSInteger count;
  if (section == kIndexSectionAccount) {
    count =  self.accountDataSource.count;
  }
  else if (section == kIndexSectionBlock) {
    count = 1;
  }
  else if (section == kIndexSectionSignOut) {
    count = 1;
  }
  return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  UITableViewCell *cell = nil;
  
  if (indexPath.section == kIndexSectionAccount) {
    
    cell = [tableView dequeueReusableCellWithIdentifier:kSettingsCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSettingsCellIdentifier];
    }
    [cell.textLabel setText:[(NSDictionary*)_accountDataSource[indexPath.row] objectForKey:kTextLeft]];
    [cell.detailTextLabel setText:[(NSDictionary*)_accountDataSource[indexPath.row] objectForKey:kTextRight]];
  }
  else if (indexPath.section == kIndexSectionBlock) {
    
    cell = [tableView dequeueReusableCellWithIdentifier:kSettingsCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSettingsCellIdentifier];
    }
    [cell.textLabel setText:kManageBlkdUsers];
    [cell.detailTextLabel setText:kEmptyStringValue];
  }
  else if (indexPath.section == kIndexSectionSignOut) {
    
    cell = [tableView dequeueReusableCellWithIdentifier:kSettingsSignOutCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingsSignOutCellIdentifier];
    }
  }
  [cell layoutIfNeeded];
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
  if (section == kIndexSectionAccount) {
    sectionLabel.text = kAccountTitle;
  } else {
    sectionLabel.text = kEmptyStringValue;
  }
  return  headerView ;
}


#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == kIndexSectionAccount) {
    NSString *fbUserId = [LCDataManager sharedDataManager].userFBID;
    switch (indexPath.row) {
      case 0:
        if (fbUserId) {
          [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"fbuser_can't_change_email", nil)];
        }
        else {
          [self showUpdateEmailScreen];
        }
        break;
        
      case 1:
        if (fbUserId) {
          [LCUtilityManager showAlertViewWithTitle:nil andMessage:NSLocalizedString(@"fbuser_can't_change_password", nil)];
        }
        else {
          [self showChangePasswordScreen];
        }
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
  else if (indexPath.section == kIndexSectionBlock) {
    [self showBlockedUsersList];
  }
  else if (indexPath.section == kIndexSectionSignOut) {
    [self signOut];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)signOut
{
  //sign out
  UIAlertController *signOutAlert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"signout_alert_message", nil) preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"signOut", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    [self signOutLegacy];
  }];
  [signOutAlert addAction:okAction];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)  style:UIAlertActionStyleCancel handler:nil];
  [signOutAlert addAction:cancelAction];
  [self presentViewController:signOutAlert animated:YES completion:nil];
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

- (void)showBlockedUsersList
{
//  LCPrivacyViewController * privacyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCPrivacyVC"];
//  [self presentViewController:privacyVC animated:YES completion:nil];
}

- (void) signOutLegacy {
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCSettingsAPIManager signOutwithSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    //[LCUtilityManager clearUserDefaultsForCurrentUser];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    BOOL tutorialPresent = [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialPresentKey];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] setBool:tutorialPresent forKey:kTutorialPresentKey];//tutorial should persist
    [LCDataManager resetSharedManager];
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
