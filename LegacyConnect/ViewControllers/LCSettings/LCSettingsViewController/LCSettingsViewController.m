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
  self.clearsSelectionOnViewWillAppear = NO;
  self.navigationController.navigationBarHidden = false;
  //self.title = kSettingsScreenTitle;
  UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(doneButtonPressed:)];
  [doneButton setTintColor:[UIColor blackColor]];
  self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)prepareDataSource {
  
  NSString * userEmail = [LCDataManager sharedDataManager].userEmail ? [LCDataManager sharedDataManager].userEmail : kEmptyStringValue;
  NSString * firstName = [LCDataManager sharedDataManager].firstName ? [LCDataManager sharedDataManager].firstName : kEmptyStringValue;
  NSString * lastName = [LCDataManager sharedDataManager].lastName ? [LCDataManager sharedDataManager].lastName : kEmptyStringValue;
  
  self.accountDataSource = @[ @{kTextLeft : kEmailAddress, kTextRight : userEmail},
                              @{kTextLeft : kChangePassword, kTextRight : kEmptyStringValue},
                              @{kTextLeft : kMyLegacyURL, kTextRight : [NSString stringWithFormat:@"%@ %@",firstName,
                                                                        lastName]},
                              @{kTextLeft : kPrivacy, kTextRight : kEmptyStringValue} ];
  
  self.signOutDataSource = @[ @{kTextLeft : kSignOut, kTextRight : kEmptyStringValue} ];
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
  [self prepareDataSource];
  [self.tableView reloadData];
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
      return self.signOutDataSource.count;
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsCellIdentifier forIndexPath:indexPath];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSettingsCellIdentifier];
  }
  
  NSArray * currentDataSource = nil;
  
  switch (indexPath.section)
  {
    case kIndexSectionAccount:
      currentDataSource = self.accountDataSource;
      break;
      
    case kIndexSectionSignOut:
      currentDataSource = self.signOutDataSource;
      break;

    default:
      break;
  }
  
  [cell.textLabel setText:[(NSDictionary*)[currentDataSource objectAtIndex:indexPath.row] objectForKey:kTextLeft]];
  [cell.detailTextLabel setText:[(NSDictionary*)[currentDataSource objectAtIndex:indexPath.row] objectForKey:kTextRight]];
  
  if (indexPath.section == kIndexSectionSignOut)
  {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section)
  {
    case kIndexSectionAccount:
      return kAccountTitle;
      break;
      
    default:
      return kEmptyStringValue;
      break;
  }
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
}

- (void)showUpdateEmailScreen
{
  LCUpdateEmailViewController * updateMailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCUpdateEmailVC"];
  updateMailVC.emailAddress = [LCDataManager sharedDataManager].userEmail;
  [self.navigationController pushViewController:updateMailVC animated:YES];
}

- (void)showChangePasswordScreen
{
  LCChangePasswordViewController * passwordVc = [self.storyboard instantiateViewControllerWithIdentifier:@"LCChangePasswordVC"];
  [self.navigationController pushViewController:passwordVc animated:YES];
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
