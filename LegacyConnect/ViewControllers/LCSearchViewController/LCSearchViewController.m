//
//  LCSearchViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 8/26/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSearchViewController.h"
#import "LCChooseCausesCollectionViewCell.h"

@interface LCSearchViewController ()
{
  LCSearchResult *searchResultObject;
  NSArray *tableData;
}
@end

@implementation LCSearchViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.searchBar becomeFirstResponder];
  
  UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [topButton setTitle:@"Top" forState:UIControlStateNormal];
  UIButton *usersButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [usersButton setTitle:@"Users" forState:UIControlStateNormal];
  UIButton *interestsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [interestsButton setTitle:@"Interests" forState:UIControlStateNormal];
  UIButton *causesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [causesButton setTitle:@"Causes" forState:UIControlStateNormal];
  
  self.tabMenu.menuButtons = @[topButton,usersButton ,interestsButton, causesButton];
  self.tabMenu.views = @[_topTableView, _usersTableView, _interestsTableView, _collectionView];
  
  self.tabMenu.highlightColor = [UIColor orangeColor];
  self.tabMenu.normalColor = [UIColor blackColor];
  
  self.topTableView.rowHeight = UITableViewAutomaticDimension;
  self.usersTableView.rowHeight = UITableViewAutomaticDimension;
  self.interestsTableView.rowHeight = UITableViewAutomaticDimension;
  self.topTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.usersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.interestsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if([tableView isEqual:_topTableView])
  {
    return 3;
  }
  else
  {
    return 1;
  }//count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if([tableView isEqual:_topTableView])
  {
    if(section == 0)
      return searchResultObject.usersArray.count;
    else if(section == 1)
      return searchResultObject.interestsArray.count;
    else
      return searchResultObject.causesArray.count;
  }
  else  if([tableView isEqual:_usersTableView])
  {
    return searchResultObject.usersArray.count;
  }
  else
  {
    return searchResultObject.interestsArray.count;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if([tableView isEqual:_topTableView])
  {
    NSString *sectionName;
    switch (section)
    {
      case 0:
        sectionName = @"Users";
        break;
      case 1:
        sectionName = @"Interests";
        break;
        // ...
      default:
        sectionName = @"Causes";
        break;
    }
    return sectionName;
  }
  return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([tableView isEqual:_topTableView])
  {
    static NSString *MyIdentifier = @"userTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(indexPath.section == 0)
    {
      LCUserDetail *user = searchResultObject.usersArray[indexPath.row];
      cell.textLabel.text = user.firstName;
    }
    else if(indexPath.section == 1)
    {
      LCInterest *interest = searchResultObject.interestsArray[indexPath.row];
      cell.textLabel.text = interest.name;
    }
    else
    {
      LCCause *cause = searchResultObject.causesArray[indexPath.row];
      cell.textLabel.text = cause.name;
    }
    return cell;
  }
  else if([tableView isEqual:_usersTableView])
  {
    static NSString *MyIdentifier = @"userTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    LCUserDetail *user = searchResultObject.usersArray[indexPath.row];
    cell.textLabel.text = user.firstName;
    return cell;
  }
  else
  {
    static NSString *MyIdentifier = @"userTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    LCInterest *interest = searchResultObject.interestsArray[indexPath.row];
    cell.textLabel.text = interest.name;
    return cell;
  }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return searchResultObject.causesArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"causesCollectionViewCell";
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  
  cell.cause = searchResultObject.causesArray[indexPath.item];
  
  return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  [LCAPIManager searchForItem:@"" withSuccess:^(LCSearchResult *searchResult) {
    NSLog(@"%@",searchResult);
    searchResultObject = searchResult;
    [self reloadAllViews];
  } andFailure:^(NSString *error) {
    NSLog(@"");
  }];
}


- (IBAction)searchCancelButtonClicked:(UIButton *)cancelButton
{
  [self.navigationController popViewControllerAnimated:NO];
}

-(void)reloadAllViews
{
  [self.topTableView reloadData];
  [self.usersTableView reloadData];
  [self.interestsTableView reloadData];
  [self.collectionView reloadData];
}
@end
