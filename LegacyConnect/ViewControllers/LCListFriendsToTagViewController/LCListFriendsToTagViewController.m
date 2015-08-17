//
//  LCListFriendsToTagViewController.m
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCListFriendsToTagViewController.h"
#import "LCTagFriendsTableViewCell.h"

@interface LCListFriendsToTagViewController ()
{
  NSMutableArray *friendsArray;
  NSMutableArray *tableSourceArray;
}
@end

@implementation LCListFriendsToTagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  friendsArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", nil];
  tableSourceArray = [[NSMutableArray alloc] initWithArray:friendsArray];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma searchbar delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  NSLog(@"searchText :%@",searchText);
}


#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return tableSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"LCTagFriendsTableViewCell";
  LCTagFriendsTableViewCell *cell = (LCTagFriendsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    NSArray *customCellArray = [[NSBundle mainBundle] loadNibNamed:MyIdentifier owner:nil options:nil];
    cell = [customCellArray objectAtIndex:0];
  }
  
  cell.friendNameLabel.text = tableSourceArray[indexPath.row];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}


@end
