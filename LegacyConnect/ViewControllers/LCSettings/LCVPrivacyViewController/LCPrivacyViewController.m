//
//  LCPrivacyTableViewController.m
//  LegacyConnect
//
//  Created by qbuser on 14/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCPrivacyViewController.h"

#define kPrivacyCellIdentifier @"LCPrivacyCell"

@implementation LCPrivacyViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialUISetUp];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


- (void)initialUISetUp
{
  
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
  headerView.backgroundColor = self.tableView.separatorColor;
  self.tableView.tableHeaderView = headerView;
  
  UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
  footerView.backgroundColor = self.tableView.separatorColor;
  self.tableView.tableFooterView = footerView;
  
  _selectedIndex = [_settingsData.availablePrivacy indexOfObject:_settingsData.privacy];
  [self validateFields];
}

- (void) validateFields{
  
  if (_selectedIndex != [_settingsData.availablePrivacy indexOfObject:_settingsData.privacy]) {
    saveButton.enabled = YES;
  }
  else {
    saveButton.enabled = NO;
  }
}


#pragma mark - Action methods
- (IBAction)cancelAction:(id)sender {
  
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveAction:(id)sender {
  
  NSString *newPrivacy = [_settingsData.availablePrivacy objectAtIndex:_selectedIndex];
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCSettingsAPIManager changePrivacy:newPrivacy withSuccess:^(id response) {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    _settingsData.privacy = newPrivacy;
    [self.delegate updateView];
    [self dismissViewControllerAnimated:YES completion:nil];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    LCDLog(@"error - %@",error);
  }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _settingsData.availablePrivacy.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPrivacyCellIdentifier forIndexPath:indexPath];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPrivacyCellIdentifier];
  }
  [cell.textLabel setText:[_settingsData.availablePrivacy objectAtIndex:indexPath.row]];
  if (indexPath.row == _selectedIndex)
  {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }
  else
  {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}

#pragma mark - UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  _selectedIndex = indexPath.row;
  [self.tableView reloadData];
  [self validateFields];
}


@end
