//
//  LCPrivacyTableViewController.m
//  LegacyConnect
//
//  Created by qbuser on 14/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCPrivacyViewController.h"

@interface LCPrivacyViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic) NSInteger selectedIndex;
@end

#define kPrivacyCellIdentifier @"LCPrivacyCell"

@implementation LCPrivacyViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
  headerView.backgroundColor = self.tableView.separatorColor;
  self.tableView.tableHeaderView = headerView;
  
  UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
  footerView.backgroundColor = self.tableView.separatorColor;
  self.tableView.tableFooterView = footerView;
  
  self.dataSource = @[@"Only Me", @"Friends Only", @"Public"];
  _selectedIndex = [self.dataSource indexOfObject:_settingsData.privacy];
  //[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - Action methods
- (IBAction)cancelAction:(id)sender {
  
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)saveAction:(id)sender {
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPrivacyCellIdentifier forIndexPath:indexPath];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPrivacyCellIdentifier];
  }
  [cell.textLabel setText:[self.dataSource objectAtIndex:indexPath.row]];
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
}


@end
