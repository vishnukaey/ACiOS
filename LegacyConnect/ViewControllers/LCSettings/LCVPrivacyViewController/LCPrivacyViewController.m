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
@property (nonatomic) NSIndexPath * selectedIndexPath;
@end

#define kPrivacyCellIdentifier @"LCPrivacyCell"

@implementation LCPrivacyViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.dataSource = @[@"Only Me", @"Friends Only", @"Public"];
  self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
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
  if (indexPath == self.selectedIndexPath)
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
  self.selectedIndexPath = indexPath;
  [self.tableView reloadData];
}


@end
